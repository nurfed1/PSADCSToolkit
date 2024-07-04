<#
.SYNOPSIS
Resolves the name and display name of an Active Directory schema object or extended right based on its GUID.

.DESCRIPTION
This function takes a GUID and searches the Active Directory schema and extended rights to find the corresponding object or right name and display name.
It returns these properties if found.

.PARAMETER ObjectGuid
Specifies the GUID of the Active Directory schema object or extended right to be resolved.

.PARAMETER Server
Specifies the Active Directory server to connect to for the query.

.OUTPUTS
System.Object
Returns an object containing the name and display name of the resolved schema object or extended right.

.EXAMPLE
PS C:\> Resolve-SchemaRightsName -ObjectGuid "550e8400-e29b-41d4-a716-446655440000"

Resolves the name and display name of the schema object or extended right with the specified GUID.
#>
function Resolve-SchemaRightsName {
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Guid]$ObjectGuid,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )

    begin {
        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $server
        }

        $rootDSE = (Get-ADRootDSE @common)
        $extRightsPath = "CN=Extended-Rights,$($rootDSE.ConfigurationNamingContext)"
        $schemaPath = $rootDSE.schemaNamingContext
    }

    process {
        $property = Get-ADObject @common -SearchBase $extRightsPath -Filter { RightsGUID -eq $ObjectGuid } -Properties Name, displayName | Select-Object -Property Name, displayName

        if (-not $property) {
            $property = Get-ADObject @common -SearchBase $schemaPath -Filter { SchemaIDGUID -eq $ObjectGuid } -Properties Name, displayName | Select-Object -Property Name, displayName
        }

        Write-Output -InputObject $property
    }
}
