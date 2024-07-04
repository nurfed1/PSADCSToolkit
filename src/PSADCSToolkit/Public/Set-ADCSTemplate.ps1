<#
.SYNOPSIS
Updates the properties of an ADCS (Active Directory Certificate Services) certificate template.

.DESCRIPTION
This function updates the properties of an ADCS certificate template based on the specified name and provided input (JSON or object). It supports updating issuance policies, and other properties as defined in the ADCSTemplatePropertyMap. The function supports ShouldProcess for confirmation prompts and can output the updated template if requested.

.PARAMETER Name
Specifies the name of the ADCS certificate template to update.

.PARAMETER Json
Specifies the JSON string representing the properties to update.

.PARAMETER InputObject
Specifies the object representing the properties to update.

.PARAMETER PassThru
If specified, the function returns the updated template object.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, the default server is used.

.OUTPUTS
PSCustomObject with type 'ADCSTemplate' - if the passthru parameter is set.

.EXAMPLE
PS C:\> Set-ADCSTemplate -Name "UserTemplate" -Json '{"displayName":"Updated User Template"}'

This example updates the display name of the certificate template named "UserTemplate" to "Updated User Template" using a JSON input.
#>
Function Set-ADCSTemplate {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType('ADCSTemplate')]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [System.String]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'JsonInput')]
        [ValidateNotNullOrEmpty()]
        [System.String]$Json,

        [Parameter(Mandatory = $true, ParameterSetName = 'ObjectInput')]
        [ValidateNotNullOrEmpty()]
        [System.Object]$InputObject,

        [Parameter(Mandatory = $false)]
        [switch]$PassThru = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )

    begin {
        $ErrorActionPreference = 'Stop'

        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $server
        }

        if ($PSBoundParameters.ContainsKey('Json')) {
            $InputObject = $Json | ConvertFrom-Json
        }

        $importProperties = ($script:ADCSTemplatePropertyMap | Where-Object { $_.Import -eq $true })
    }

    process {
        $templates = Get-ADCSTemplate @common -Name $Name

        foreach ($template in $templates) {
            $replaceProperties = @{}
            # $clearProperties = @()

            foreach ($property in $importProperties) {
                $propertyName = $property.ADProperty
                $propertyType = $property.ADType

                if ($propertyName -in $InputObject.PSobject.Properties.name) {
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

                    if (($null -ne $inputValue -and $null -eq $template.$propertyName) -or
                    ($null -eq $inputValue -and $null -ne $template.$propertyName) -or
                    (Compare-Object -ReferenceObject $inputValue -DifferenceObject $template.$propertyName)) {

                        Write-verbose -Verbose -Message "Updating '$propertyName'."
                        $replaceProperties[$propertyName] = $inputValue
                    }
                }
            }

            $changed = $false
            if ($replaceProperties.Count -gt 0) {
                if ($PSCmdlet.ShouldProcess($template.DistinguishedName, "Updating certificate template '$($template.Name)'")) {
                    Set-ADObject @common -Identity $template.DistinguishedName -Replace $replaceProperties
                    $changed = $true
                }
            }

            if ($PassThru) {
                if ($PSCmdlet.ShouldProcess($template.DistinguishedName, "Retrieving certificate template '$($template.Name)")) {
                    if ($changed) {
                        $template = (Get-ADCSTemplate @common -Name $template.Name)
                    }

                    Write-Output -InputObject $template
                }
            }
        }
    }
}
