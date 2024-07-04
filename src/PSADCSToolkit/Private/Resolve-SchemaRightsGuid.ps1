<#
.SYNOPSIS
Resolves the GUID of an Active Directory schema object or extended right based on its name.

.DESCRIPTION
This function takes the name of an Active Directory schema object or extended right and searches the schema and extended rights paths to find the corresponding GUID.
It returns the GUID if found.

.PARAMETER ObjectName
Specifies the name of the Active Directory schema object or extended right to be resolved.

.PARAMETER Server
Specifies the Active Directory server to connect to for the query. This parameter is optional.

.OUTPUTS
System.Guid
Returns the GUID of the resolved schema object or extended right.

.EXAMPLE
PS C:\> Resolve-SchemaRightsGuid -SchemaName "Certificate-Enrollment"

Resolves the GUID of the schema object or extended right with the specified name.
#>
function Resolve-SchemaRightsGuid {
    [CmdletBinding()]
    [OutputType([System.Guid])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]$ObjectName,

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
        $objectGuid = Get-ADObject @common -SearchBase $extRightsPath -Filter { Name -eq $ObjectName } -Properties RightsGUID | Select-Object -ExpandProperty RightsGUID

        if (-not $objectGuid) {
            $objectGuid = Get-ADObject @common -SearchBase $schemaPath -Filter { Name -eq $ObjectName } -Properties SchemaIDGUID | Select-Object -ExpandProperty SchemaIDGUID
        }


        if ($objectGuid) {
            Write-Output -InputObject ([System.Guid]$objectGuid)
        }
    }
}
