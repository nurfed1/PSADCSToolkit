<#
.SYNOPSIS
Exports the ADCS issuance policies to JSON format.

.DESCRIPTION
This function exports the specified ADCS issuance policies to JSON format. It supports exporting by policy name,
display name, or directly from an input object.

.PARAMETER Name
Specifies the name of the issuance policy to export.

.PARAMETER DisplayName
Specifies the display name of the issuance policy to export.

.PARAMETER InputObject
Specifies the issuance policy object to export.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, the default server is used.

.OUTPUTS
System.String - JSON representation of the ADCS issuance policy

.EXAMPLE
PS C:\> Export-ADCSIssuancePolicy -Name '29.74933F91AB47F116CEC3207E23EB1B18'

This example exports the issuance policy named '29.74933F91AB47F116CEC3207E23EB1B18' to JSON format.

.EXAMPLE
PS C:\> Export-ADCSIssuancePolicy -DisplayName 'User Policy'

This example exports the issuance policy with the display name 'User Policy' to JSON format.

.EXAMPLE
PS C:\> mkdir ADCSPolicies -Force
PS C:\> cd ADCSPolicies
PS C:\> Get-ADCSIssuancePolicy | ForEach-Object {
PS C:\>     "Exporting $_.Name"
PS C:\>     $_ | Export-ADCSIssuancePolicy | Out-File -FilePath "$($_.Name).json" -Force
PS C:\> }

Export all issuance policies to JSON.
#>
function Export-ADCSIssuancePolicy {
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
        [PSTypeName('ADCSIssuancePolicy')]$InputObject,

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

        $policies = Get-ADCSIssuancePolicy @common @params

        foreach ($policy in $policies) {
            Write-Output -InputObject ($policy | ConvertTo-Json -Depth 3)
        }
    }
}
