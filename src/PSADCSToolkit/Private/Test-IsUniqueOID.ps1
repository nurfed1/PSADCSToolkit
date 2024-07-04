<#
.SYNOPSIS
Tests if a given OID (Object Identifier) is unique within the ADCS (Active Directory Certificate Services) environment.

.DESCRIPTION
This function checks if a specified OID is unique within the Active Directory environment by querying the OID container under the Public Key Services.

.PARAMETER Name
Specifies the name of the OID to check. The name must match the pattern of one or more digits followed by a dot and a 32-character hexadecimal string.

.PARAMETER TemplateOID
Specifies the template OID to check for uniqueness.

.PARAMETER Server
Specifies the Active Directory server to connect to for the query. If not provided, the default server is used.

.OUTPUTS
System.Boolean
Returns $true if the OID is unique, otherwise returns $false.

.EXAMPLE
PS C:\> Test-IsUniqueOID -Name "3059767.5E9F0AE1332868142EB247907438E0A5" -TemplateOID "1.3.6.1.4.1.311.21.8.13902780.12856267.13505254.14215583.12566103.9.1495200.3059767"

Checks if the OID "1.3.6.1.4.1.311.21.8.13902780.12856267.13505254.14215583.12566103.9.1495200.3059767" with the name "3059767.5E9F0AE1332868142EB247907438E0A5" is unique.
#>
Function Test-IsUniqueOID {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^\d+\.[0-9a-fA-F]{32}$')]
        [System.String]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$TemplateOID,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )

    process {
        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $Server
        }

        $configNC = (Get-ADRootDSE @common).configurationNamingContext
        $oidPath = "CN=OID,CN=Public Key Services,CN=Services,$configNC"

        $search = Get-ADObject @common -SearchBase $oidPath -Filter { Name -eq $Name -and msPKI-Cert-Template-OID -eq $TemplateOID }

        Write-Output -InputObject (-not $search)
    }
}
