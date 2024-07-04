<#
.SYNOPSIS
Exports Active Directory Certificate Services (ADCS) certificate templates to JSON.

.DESCRIPTION
Retrieves and exports ADCS certificate templates based on name, display name, or input object.
Optionally includes ACL and issuance policies in the export.

.PARAMETER Name
Specifies the name of the ADCS certificate template to export.

.PARAMETER DisplayName
Specifies the display name of the ADCS certificate template to export.

.PARAMETER InputObject
Specifies an ADCSTemplate object from which to export properties.

.PARAMETER ExportAcl
Indicates whether to include the ACLs in the exported template.

.PARAMETER IncludePrincipalDomain
Indicates whether to include the domain part in the principal names in the ACLs.

.PARAMETER Server
Specifies the server to connect to for retrieving ADCS information.

.OUTPUTS
System.String - JSON representation of the ADCS template

.EXAMPLE
PS C:\> Export-ADCSTemplate -Name "WebServer"

Exports the ADCS certificate template with the name "WebServer" to JSON.

.EXAMPLE
PS C:\> Export-ADCSTemplate -DisplayName "Web Server Authentication"

Exports the ADCS certificate template with the display name "Web Server Authentication" to JSON.

.EXAMPLE
PS C:\> Get-ADCSTemplate -Name "UserTemplate" | Export-ADCSTemplate -IncludePrincipalDomain

Exports all ADCS certificate templates from the specified input objects to JSON.

.EXAMPLE
PS C:\> Export-ADCSTemplate -Name "WebServer" -ExportAcl -IncludePrincipalDomain

Exports the ADCS certificate template with the name "WebServer" to JSON, including ACL information with domain parts.

.EXAMPLE
PS C:\> mkdir ADCSTemplates -Force
PS C:\> cd ADCSTemplates
PS C:\> Export-ADCSTemplate | ForEach-Object {
PS C:\>     "Exporting $_.Name"
PS C:\>     $_ | Export-ADCSTemplate | Out-File -FilePath "$($_.Name).json" -Force
PS C:\> }

Export all templates to JSON.
#>
function Export-ADCSTemplate {
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Name'
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [System.String]$Name,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'DisplayName'
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [System.String]$DisplayName,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'InputObject'
        )]
        [PSTypeName('ADCSTemplate')]$InputObject,

        [Parameter(Mandatory = $false)]
        [switch]$ExportAcl = $false,

        [Parameter(Mandatory = $false)]
        [switch]$IncludePrincipalDomain = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )
    begin {
        $ErrorActionPreference = 'Stop'

        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $Server
        }

        # Only export AD properties
        $exportProperties = $script:ADCSTemplatePropertyMap | Where-Object -Property Export -EQ $true | Select-Object -ExpandProperty ADProperty

        $policyCache = @{}
    }

    process {
        $params = @{}
        if ($PSBoundParameters.ContainsKey('Name')) {
            $params.Name = $Name
        }
        elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
            $params.DisplayName = $DisplayName
        }
        elseif ($PSBoundParameters.ContainsKey('InputObject')) {
            # Request all properties,
            # It doesn't makes sense to export only partial properties
            $params.Name = $InputObject.Name
        }

        $templates = Get-ADCSTemplate @common @params

        foreach ($template in $templates) {
            # Filter export properties that are present in the template.
            # This prevents exporting null properties
            $properties = Compare-Object -ReferenceObject $exportProperties -DifferenceObject $template.PSObject.Properties.Name -IncludeEqual -ExcludeDifferent | Select-Object -ExpandProperty InputObject
            $template = $template | select-Object -Property $properties

            # Export issuance policies
            $policies = [System.Collections.ArrayList]@()

            $oids = ($template.'msPKI-Certificate-Policy' + $template.'msPKI-RA-Policies' | Select-Object -Unique)
            foreach ($oid in $oids) {
                if ($policyCache.Contains($oid)) {
                    $policies.Add($policyCache.Item($oid)) | Out-Null
                }
                else {
                    try {
                        # Not all issuance policies are stored in AD
                        # We only export custom policies
                        $policy = Get-ADCSIssuancePolicy @common -Oid $oid

                        $policyCache.Add($oid, $policy)
                        $policies.Add($policy) | Out-Null
                    }
                    catch [ADCSIssuancePolicyNotFoundException] {
                        # Non Fatal error
                        Write-Verbose -Message "Failed to export issuance policy with oid '$oid'"
                    }
                }
            }

            if ($policies.Count -gt 0) {
                $template | Add-Member -Type NoteProperty -Name IssuancePolicies -Value $policies
            }

            # Export Acl
            if ($ExportAcl) {
                $templateAcl = Get-ADCSTemplateAcl @common -Name $template.Name -IncludePrincipalDomain:$IncludePrincipalDomain
                $template | Add-Member -Type NoteProperty -Name Acl -Value $templateAcl
            }

            Write-Output -InputObject ($template | ConvertTo-Json -Depth 3)
        }
    }
}