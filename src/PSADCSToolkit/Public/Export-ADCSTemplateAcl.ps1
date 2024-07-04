<#
.SYNOPSIS
Exports the ACL of ADCS templates to JSON format.

.DESCRIPTION
This function exports the Access Control List (ACL) of the specified ADCS templates to JSON format.

.PARAMETER Name
Specifies the name of the ADCS template whose ACL is to be exported.

.PARAMETER DisplayName
Specifies the display name of the ADCS template whose ACL is to be exported.

.PARAMETER InputObject
Specifies the ADCS template ACL object to be exported.

.PARAMETER IncludePrincipalDomain
Includes the principal domain information in the output.

.PARAMETER IncludeInheritedAce
Includes inherited Dacl and Sacl aces in the output.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, the default server is used.

.OUTPUTS
System.String - JSON representation of the ADCS template ACL

.EXAMPLE
PS C:\> Export-ADCSTemplateAcl -Name 'User'

This example exports the ACL of the ADCS template named 'User' to JSON format.

.EXAMPLE
PS C:\> Export-ADCSTemplateAcl -DisplayName 'User Template'

This example exports the ACL of the ADCS template with the display name 'User Template' to JSON format.

.EXAMPLE
PS C:\> Export-ADCSTemplateAcl -Name 'UserTemplate' -IncludePrincipalDomain

This example exports the ACL of the ADCS template named 'UserTemplate' to JSON format, including principal domain information.
#>
function Export-ADCSTemplateAcl {
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
        [PSTypeName('ADCSTemplateAcl')]$InputObject,

        [Parameter()]
        [switch]$IncludePrincipalDomain = $false,

        [Parameter()]
        [switch]$IncludeInheritedAce = $false,

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

        $templateAcls = Get-ADCSTemplateAcl @common @params -IncludePrincipalDomain:$IncludePrincipalDomain -ExcludeInheritedAce:(-not $IncludeInheritedAce)

        foreach ($templateAcl in $templateAcls) {
            Write-Output -InputObject ($templateAcl | ConvertTo-Json -Depth 3)
        }
    }
}