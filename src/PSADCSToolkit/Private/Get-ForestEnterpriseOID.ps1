<#
.SYNOPSIS
Retrieves the forest's enterprise OID prefix.

.DESCRIPTION
This function retrieves the enterprise OID prefix for the current Active Directory forest.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, uses the default server.

.OUTPUTS
System.String
Returns a string containing the forest's enterprise OID prefix.

.EXAMPLE
PS C:\> Get-ForestEnterpriseOID

Retrieves the enterprise OID prefix for the current Active Directory forest.
#>
function Get-ForestEnterpriseOID {
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )

    process {
        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $server
        }

        $configNC = (Get-ADRootDSE @common).configurationNamingContext
        $forestOIDPath = "CN=OID,CN=Public Key Services,CN=Services,$configNC"
        $forestOID = (Get-ADObject @common -Identity $forestOIDPath -Properties msPKI-Cert-Template-OID | Select-Object -ExpandProperty msPKI-Cert-Template-OID)

        Write-Output -InputObject $forestOID
    }
}