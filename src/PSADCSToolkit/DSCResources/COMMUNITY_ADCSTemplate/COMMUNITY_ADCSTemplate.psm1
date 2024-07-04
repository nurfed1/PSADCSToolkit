#requires -Version 5.0 -Modules PSADCSToolkit
Set-StrictMode -Version 5.0

$modulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$propertyMapPath = Join-Path -Path $modulePath -ChildPath "PropertyMaps"

$ADCSTemplatePropertyMapPath = Join-Path -Path $propertyMapPath -ChildPath "ADCSTemplate.PropertyMap.ps1"
$script:ADCSTemplatePropertyMap = (. $ADCSTemplatePropertyMapPath).Properties
$script:ADProperties = $script:ADCSTemplatePropertyMap | Where-Object { $_.Import -eq $true } | Select-Object -ExpandProperty ADProperty
$script:AclProperties = @(
    "Group"
    "Owner"
    "DACLs"
    "SACLs"
    "AreAccessRulesProtected"
    "AreAuditRulesProtected"
)
$script:DaclAceProperties = @(
    "IdentityReference"
    "ActiveDirectoryRights"
    "AccessControlType"
    "ObjectType"
    "InheritanceType"
    "InheritedObjectType"
)
$script:SaclAceProperties = @(
    "IdentityReference"
    "ActiveDirectoryRights"
    "AuditFlags"
    "ObjectType"
    "InheritanceType"
    "InheritedObjectType"
)

function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Name,

        [Parameter(Mandatory = $false)]
        [System.Boolean]$ImportAcl = $false,

        [Parameter(Mandatory = $false)]
        [System.Boolean]$ImportEnrollmentServices = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )

    $common = @{}
    if ($PSBoundParameters.ContainsKey('Server')) {
        $common.Server = $server
    }

    Write-Verbose -Message "Retrieving template '$Name'."

    try {
        $template = Get-ADCSTemplate @common -Name $Name

        if ($ImportAcl) {
            $templateAcl = Get-ADCSTemplateAcl @common -Name $Name -ExcludeInheritedAce
        }

        if ($ImportEnrollmentServices) {
            $enrollmentServices = Get-ADCSEnrollmentService @common | Where-Object -FilterScript { $_.certificateTemplates -contains $Name } | Select-Object -ExpandProperty Name
        }
    }
    catch [ADCSTemplateNotFoundException] {
        Write-Verbose -Message "Template '$Name' is not present."

        $template = $null
    }
    catch {
        throw [InvalidOperationException]::new("Error retrieving '$Name'.")
    }

    if ($template) {
        Write-Verbose -Message "Template '$Name' is present."

        $targetResource = @{
            Ensure = 'Present'
        }

        # Retrieve each property from the ADCSTemplatePropertyMap and add to the hashtable
        foreach ($propertyName in $script:ADProperties) {
            if ($propertyName -in $template.PSobject.Properties.name) {
                $value = $template.$propertyName

                $targetResource.Add($propertyName, $value)
            }
            else {
                $targetResource.Add($propertyName, $null)
            }
        }

        if ($ImportAcl) {
            $targetAcl = @{}

            foreach ($propertyName in $script:AclProperties) {
                if ($propertyName -in $templateAcl.PSobject.Properties.name) {
                    $value = $templateAcl.$propertyName

                    $targetAcl.Add($propertyName, $value)
                }
                else {
                    $targetAcl.Add($propertyName, $null)
                }
            }
            $targetResource.Add('Acl', $targetAcl)
        }

        if ($ImportEnrollmentServices) {
            $targetResource.Add('EnrollmentServices', $enrollmentServices)
        }
    }
    else {
        $targetResource = @{
            Ensure = 'Absent'
        }

        foreach ($propertyName in $script:ADProperties) {
            $targetResource.Add($propertyName, $null)
        }

        if ($ImportAcl) {
            $targetResource.Add('Acl', $null)
        }

        if ($ImportEnrollmentServices) {
            $targetResource.Add('EnrollmentServices', $null)
        }
    }

    return $targetResource
}


function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Name,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Json,

        [Parameter(Mandatory = $false)]
        [System.Boolean]$ImportAcl = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$EnrollmentServices,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Present", "Absent")]
        [System.String] $Ensure
    )

    $common = @{}
    if ($PSBoundParameters.ContainsKey('Server')) {
        $common.Server = $server
    }

    $importEnrollmentServices = $false
    if ($PSBoundParameters.ContainsKey('EnrollmentServices')) {
        $importEnrollmentServices = $true

        # Ensure unique
        $EnrollmentServices = [System.String[]][System.Linq.Enumerable]::Distinct($EnrollmentServices, [System.StringComparer]::OrdinalIgnoreCase)
    }

    $targetResource = Get-TargetResource @common -Name $Name -ImportAcl $ImportAcl -ImportEnrollmentServices $importEnrollmentServices

    $inDesiredState = $true

    if ($targetResource.Ensure -eq 'Present') {
        if ($Ensure -eq 'Present') {
            $inputObject = $Json | ConvertFrom-Json
            if ("Name" -in $inputObject.PSObject.Properties.Name) {
                $inputObject.Name = $Name
            }
            else {
                $inputObject | Add-Member -Type NoteProperty -Name Name -Value $Name
            }

            foreach ($property in ($script:ADCSTemplatePropertyMap | Where-Object { $_.Import -eq $true })) {
                $propertyName = $property.ADProperty
                $propertyType = $property.ADType

                if ($propertyName -in $inputObject.PSObject.Properties.Name) {
                    $inputValue = ($inputObject.$propertyName -as $PropertyType)
                }
                else {
                    $inputValue = $null
                }

                # Issuance policy post processing
                if ($inputValue -and ($propertyName -in @('msPKI-Certificate-Policy', 'msPKI-RA-Policies'))) {
                    $updatedPolicyOids = [System.Collections.ArrayList]@()

                    $policyOids = $inputValue
                    foreach ($oid in $policyOids) {
                        $backupIssuancePolicy = $inputObject.IssuancePolicies | Where-Object -Property msPKI-Cert-Template-OID -EQ -Value $Oid
                        if ($backupIssuancePolicy) {
                            # Custom policies
                            try {
                                $issuancePolicy = Get-ADCSIssuancePolicy @common -DisplayName $backupIssuancePolicy.DisplayName
                                $updatedPolicyOids.Add($issuancePolicy.'msPKI-Cert-Template-OID') | Out-Null
                            }
                            catch [ADCSIssuancePolicyNotFoundException] {
                                Write-Error -Message "Unable to find issuance policy '$($backupIssuancePolicy.DisplayName)'."
                                # Keep original as fallback
                                $updatedPolicyOids.Add($oid) | Out-Null
                            }
                        }
                        else {
                            # Builtin policies, not existing in AD
                            $updatedPolicyOids.Add($oid) | Out-Null
                        }
                    }

                    $inputValue = ($updatedPolicyOids -as $PropertyType)
                }

                if (($null -ne $inputValue -and $null -eq $targetResource.$propertyName) -or
                    ($null -eq $inputValue -and $null -ne $targetResource.$propertyName) -or
                    (Compare-Object -ReferenceObject $inputValue -DifferenceObject $targetResource.$propertyName)) {

                    Write-Verbose -Message ("'{0}' property is NOT in the desired state. Expected '{1}', actual '{2}'." -f
                        $propertyName, ($inputValue -join '; '), ($targetResource.$propertyName -join '; '))

                    $inDesiredState = $false
                }
            }

            if ($ImportAcl) {
                if ("Acl" -in $inputObject.PSObject.Properties.Name) {
                    $targetAcl = $targetResource.Acl
                    $inputAcl = $inputObject.Acl

                    foreach ($propertyName in $script:AclProperties) {
                        if ($propertyName -in $inputAcl.PSObject.Properties.Name) {
                            $inputValue = $inputAcl.$propertyName
                        }
                        else {
                            $inputValue = $null
                        }

                        if ($propertyName -in @('DACLs', 'SACLs')) {
                            if ($propertyName -eq 'DACLs') {
                                $aceProperties = $script:DaclAceProperties
                            } else {
                                $aceProperties = $script:SaclAceProperties
                            }

                            # Exclude inherited ACLs
                            $inputValue = ($inputvalue | Where-Object -FilterScript { $_.IsInherited -eq $false })

                            # Ensure input is not $null before Compare-Object
                            if ($null -eq $inputValue) {
                                $inputValue = @()
                            }

                            # Ensure target is not $null before Compare-Object
                            $targetValue = $targetAcl.$propertyName
                            if ($null -eq $targetValue) {
                                $targetValue = @()
                            }

                            if ((Compare-Object -ReferenceObject $inputValue -DifferenceObject $targetValue -Property $aceProperties)) {
                                Write-Verbose -Message ("'{0}' ACL property is NOT in the desired state. `nExpected: {1}`n`nActual: {2}" -f
                                    $propertyName, ($inputValue | Format-List | Out-String), ($targetValue | Format-List | Out-String))

                                $inDesiredState = $false
                            }
                        }
                        else {
                            if (($null -ne $inputValue -and $null -eq $targetAcl.$propertyName) -or
                                ($null -eq $inputValue -and $null -ne $targetAcl.$propertyName) -or
                                (Compare-Object -ReferenceObject $inputValue -DifferenceObject $targetAcl.$propertyName)) {

                                Write-Verbose -Message ("'{0}' ACL property is NOT in the desired state. Expected '{1}', actual '{2}'." -f
                                    $propertyName, ($inputValue -join '; '), ($targetAcl.$propertyName -join '; '))

                                $inDesiredState = $false
                            }
                        }
                    }
                }
                else {
                    Write-Error -Message "Json does not contain ACLs."
                }
            }

            if ($importEnrollmentServices) {
                # Ensure target is not $null before Compare-Object
                $targetValue = $targetResource.EnrollmentServices
                if ($null -eq $targetValue) {
                    $targetValue = @()
                }

                if ((Compare-Object -ReferenceObject $EnrollmentServices -DifferenceObject $targetValue)) {
                    Write-Verbose -Message ("'{0}' are NOT in the desired state. Expected '{1}', actual '{2}'." -f
                        'EnrollmentServices', ($EnrollmentServices -join '; '), ($targetValue -join '; '))

                    $inDesiredState = $false
                }
            }
        }
        else {
            # Resource should be Absent
            Write-Verbose -Message "Template '$Name' is present but should be absent."

            $inDesiredState = $false
        }
    }

    else {
        # Resource is Absent
        if ($Ensure -eq 'Present') {
            # Resource should be Present
            Write-Verbose -Message "Template '$Name' is absent but should be present."

            $inDesiredState = $false
        }
        else {
            # Resource should be Absent
            Write-Verbose "Template '$Name' is in the desired state."

            $inDesiredState = $true
        }
    }

    return $inDesiredState

}

function Set-TargetResource {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Name,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String] $Json,

        [Parameter(Mandatory = $false)]
        [System.Boolean]$ImportAcl = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$EnrollmentServices,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server,

        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure
    )

    $common = @{}
    if ($PSBoundParameters.ContainsKey('Server')) {
        $common.Server = $server
    }

    $importEnrollmentServices = $false
    if ($PSBoundParameters.ContainsKey('EnrollmentServices')) {
        $importEnrollmentServices = $true

        # Ensure unique values
        $EnrollmentServices = [System.String[]][System.Linq.Enumerable]::Distinct($EnrollmentServices, [System.StringComparer]::OrdinalIgnoreCase)
    }

    $targetResource = Get-TargetResource @common -Name $Name -ImportEnrollmentServices $importEnrollmentServices

    If ($Ensure -eq 'Present') {
        if ($targetResource.Ensure -eq 'Absent') {
            Write-Verbose -Message "Creating template '$Name'."

            Write-Debug -Message ("New-ADCSTemplate Parameters: Name: '$Name', Properties: " + ($Json | Out-String))

            New-ADCSTemplate @common -Name $Name -Json $Json -ImportAcl:$ImportAcl

            if ($PSBoundParameters.ContainsKey('EnrollmentServices')) {
                Publish-ADCSTemplate @common -Name $Name -EnrollmentServices $EnrollmentServices
            }
        }
        if ($targetResource.Ensure -eq 'Present') {
            Write-Verbose -Message "Updating template '$Name'."

            Set-ADCSTemplate @common -Name $Name -Json $Json

            if ($ImportAcl) {
                $inputObject = $Json | ConvertFrom-Json

                if ("Acl" -in $inputObject.PSObject.Properties.Name) {
                    Write-Verbose -Message "Updating template ACL for '$Name'."
                    Set-ADCSTemplateAcl @common -Name $Name -InputObject $InputObject.Acl
                }
                else {
                    Write-Error -Message "Json does not contain ACLs."
                }
            }

            if ($importEnrollmentServices) {
                # Ensure target is not $null before Compare-Object
                $targetValue = $targetResource.EnrollmentServices
                if ($null -eq $targetValue) {
                    $targetValue = @()
                }

                $enrollmentServiceDiff = Compare-Object -ReferenceObject $EnrollmentServices -DifferenceObject $targetValue

                $unpublishServices = $enrollmentServiceDiff | Where-Object { $_.SideIndicator -eq '=>' } | Select-Object -ExpandProperty InputObject
                if ($unpublishServices) {
                    Write-Verbose -Message ("Unpublishing template to '{0}'." -f ($unpublishServices -join ';'))

                    Unpublish-ADCSTemplate @common -Name $Name -EnrollmentServices $unpublishServices
                }

                $publishServices = $enrollmentServiceDiff | Where-Object { $_.SideIndicator -eq '<=' } | Select-Object -ExpandProperty InputObject
                if ($publishServices) {
                    Write-Verbose -Message ("Publishing template to '{0}'." -f ($publishServices -join ';'))

                    Publish-ADCSTemplate @common -Name $Name -EnrollmentServices $publishServices
                }
            }
        }
    }

    elseif (($Ensure -eq 'Absent') -and ($targetResource.Ensure -eq 'Present')) {
        Write-Verbose "Removing template '$Name'."

        Remove-ADCSTemplate @common -Name $Name -Confirm:$false | Out-Null
    }
}

Export-ModuleMember -Function *-TargetResource