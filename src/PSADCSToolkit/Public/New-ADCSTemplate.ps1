<#
.SYNOPSIS
Creates a new Active Directory Certificate Services template based on a Json export.
Any issuance policies associated with the template will also be created.

.DESCRIPTION
The New-ADCSTemplate cmdlet creates a new certificate template in ADCS using the provided JSON data.
The cmdlet supports importing access control lists (ACLs) and issuing policies, and can publish the template to specified enrollment servers.

.PARAMETER Name
Specifies the name (CN) of the certificate template to create.

.PARAMETER Json
Specifies the JSON string that contains the properties of the certificate template to be created.

.PARAMETER InputObject
Specifies the object representing the properties to update.

.PARAMETER ImportAcl
Includes the access control list (ACL) in the created certificate template if specified.

.PARAMETER Publish
Publish the template to all Certificate Authority issuers.
Use with caution in production environments.

.PARAMETER PassThru
Returns the created certificate template object if specified.

.PARAMETER Server
Specifies the FQDN of the Active Directory Domain Controller to target for the operation.
If not specified, the nearest Domain Controller is used.

.OUTPUTS
PSCustomObject with type 'ADCSTemplate' - if the passthru parameter is set.

.EXAMPLE
PS C:\> New-ADCSTemplate -Name "NewTemplate" -Json $templateJson

Creates a new certificate template named "NewTemplate" using the JSON data provided in $templateJson.

.EXAMPLE
PS C:\> New-ADCSTemplate -Name "NewTemplate" -Json $templateJson -Publish

Creates a new certificate template named "NewTemplate" and publishes it to all enrollment services.

.EXAMPLE
PS C:\> New-ADCSTemplate -Name "NewTemplate" -Json $templateJson -ImportAcl

Creates a new certificate template named "NewTemplate", imports the ACL from the JSON data.

.EXAMPLE
PS C:\> New-ADCSTemplate -Name "NewTemplate" -Json $templateJson -PassThru

Creates a new certificate template named "NewTemplate" and returns the created template object.

.EXAMPLE
PS C:\> New-ADCSTemplate -Name UserV2 -Json (Export-ADCSTemplate -Name UserV2)
#>
function New-ADCSTemplate {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingEmptyCatchBlock", "")]
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType('ADCSTemplate')]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'JsonInput')]
        [ValidateNotNullOrEmpty()]
        [System.String]$Json,

        [Parameter(Mandatory = $true, ParameterSetName = 'ObjectInput')]
        [ValidateNotNullOrEmpty()]
        [System.Object]$InputObject,

        [Parameter(Mandatory = $false)]
        [switch]$ImportAcl = $false,

        [Parameter(Mandatory = $false)]
        [switch]$Publish = $false,

        [Parameter(Mandatory = $false)]
        [switch]$PassThru = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )

    process {
        $ErrorActionPreference = 'Stop'

        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $server
        }

        try {
            Get-ADCSTemplate @common -Name $Name | Out-Null

            # Template exists if this succeeds
            $errorRecord = New-ADCSTemplateAlreadyExistsException -Message "The specified template already exists."
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        } catch [ADCSTemplateNotFoundException] {
            # Nothing to do here
        } catch {
            $errorRecord = $_
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        if ($PSBoundParameters.ContainsKey('Json')) {
            $InputObject = $Json | ConvertFrom-Json
        }

        # definitions
        $configNC = (Get-ADRootDSE @common).configurationNamingContext
        $templateOIDPath = "CN=OID,CN=Public Key Services,CN=Services,$configNC"
        $templatePath = "CN=Certificate Templates,CN=Public Key Services,CN=Services,$configNC"

        # Create OID
        $oid = New-EnterpriseOID @common
        $otherAttributes = @{
            'DisplayName'             = $InputObject.displayName
            'flags'                   = [System.Int32]1
            'msPKI-Cert-Template-OID' = $oid.TemplateOID
        }
        if ($PSCmdlet.ShouldProcess($templateOIDPath, "Creating certificate template oid '$($oid.Name)")) {
            New-ADObject @common -Path $templateOIDPath -OtherAttributes $otherAttributes -Name $oid.Name -Type 'msPKI-Enterprise-Oid'
        }

        # Create Template
        $otherAttributes = @{
            'msPKI-Cert-Template-OID' = $oid.TemplateOID
        }

        foreach ($property in ($script:ADCSTemplatePropertyMap | Where-Object { $_.Import -eq $true })) {
            $propertyName = $property.ADProperty
            $propertyType = $property.ADType

            if (($propertyName -in $InputObject.PSobject.Properties.name) -and
                (-not [string]::IsNullOrEmpty($InputObject.$propertyName))) {
                $inputValue = ($InputObject.$propertyName -as $propertyType)

                # Issuance policy post processing
                if ($inputValue -and ($propertyName -in @('msPKI-Certificate-Policy', 'msPKI-RA-Policies'))) {
                    $updatedPolicyOids = [System.Collections.ArrayList]@()

                    $policyOids = $inputValue
                    foreach ($oid in $policyOids) {
                        $backupPolicy = $InputObject.IssuancePolicies | Where-Object -Property msPKI-Cert-Template-OID -EQ -Value $oid
                        if ($backupPolicy) {
                            # Custom policies
                            try {
                                $policy = Get-ADCSIssuancePolicy @common -DisplayName $backupPolicy.DisplayName
                                $newPolicyOid = $policy.'msPKI-Cert-Template-OID'

                                if ($oid -ne $newPolicyOid) {
                                    Write-Warning -Message "Issuance policy '$($backupPolicy.DisplayName)' with Oid '$oid' was found but did not match, updating Oid to '$newPolicyOid'"
                                }
                            }
                            catch [ADCSIssuancePolicyNotFoundException] {
                                if ($PSCmdlet.ShouldProcess($backupPolicy.DisplayName, "Creating issuance policy '$($backupPolicy.DisplayName)'")) {
                                    $policy = New-ADCSIssuancePolicy @common -DisplayName $backupPolicy.DisplayName -InputObject $backupPolicy -PassThru
                                    $newPolicyOid = $policy.'msPKI-Cert-Template-OID'
                                }
                            }

                            $updatedPolicyOids.Add($newPolicyOid) | Out-Null
                        }
                        else {
                            # Builtin policies, not existing in AD
                            $oidObject = [Security.Cryptography.Oid]::new($oid)

                            # Check if it can be resolved or print a warning,
                            # Nothing else we can do
                            if (-not $oidObject.FriendlyName) {
                                Write-Warning -Message "Builtin issuance policy with Oid '$oid' could not be resolved."
                            }

                            $updatedPolicyOids.Add($oid) | Out-Null
                        }
                    }

                    $inputValue = ($updatedPolicyOids -as $propertyType)
                }

                $otherAttributes.Add($propertyName, $inputValue)
            }
        }

        if ($PSCmdlet.ShouldProcess($templatePath, "Creating certificate template '$Name")) {
            New-ADObject @common -Name $Name -Path $templatePath -OtherAttributes $otherAttributes -Type 'pKICertificateTemplate'
        }

        if ($ImportAcl) {
            if ($InputObject.Acl) {
                if ($PSCmdlet.ShouldProcess($Name, "Setting certificate template ACL on '$Name")) {
                    Set-ADCSTemplateAcl @common -Name $Name -InputObject $InputObject.Acl
                }
            }
            else {
                Write-Error -Message "Input object does not contain acl data."
            }
        }

        if ($Publish) {
            if ($PSCmdlet.ShouldProcess($Name, "Publish certificate template '$Name")) {
                Publish-ADCSTemplate @common -Name $Name
            }
        }

        if ($PassThru) {
            if ($PSCmdlet.ShouldProcess($Name, "Retrieving certificate template '$Name")) {
                Write-Output -InputObject (Get-ADCSTemplate @common -Name $Name)
            }
        }
    }
}
