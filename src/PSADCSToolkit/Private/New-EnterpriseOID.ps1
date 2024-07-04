<#
.SYNOPSIS
Generates a new enterprise OID (Object Identifier) for use in Active Directory Certificate Services.

.DESCRIPTION
This function creates a new enterprise OID by generating a unique name and corresponding template OID.
If a name is provided, it uses that as part of the OID. Otherwise, it generates a random name and OID parts.

.PARAMETER Name
Specifies the name to be used for the OID. The name should match the pattern '^\d+\.[0-9a-fA-F]{32}$'.

.PARAMETER Server
Specifies the Active Directory server to connect to for the query.

.OUTPUTS
System.Object
Returns a custom object containing the generated Name and TemplateOID.

.EXAMPLE
PS C:\> New-EnterpriseOID -Name "12345678.0123456789abcdef0123456789abcdef"

Generates a new enterprise OID using the specified name.

.EXAMPLE
PS C:\> New-EnterpriseOID

Generates a new enterprise OID, connecting to the specified Active Directory server.
#>
function New-EnterpriseOID {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidatePattern('^\d+\.[0-9a-fA-F]{32}$')]
        [System.String]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )

    process {
        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $server
        }

        $forestOID = Get-ForestEnterpriseOID @common

        <#
        OID CN/Name                    [10000000-99999999].[32 hex characters (MD5hash)]
        OID msPKI-Cert-Template-OID    [Forest base OID].[10000000-99999999].[10000000-99999999]  <--- second number same as first number in OID name
        #>

        if ($PSBoundParameters.ContainsKey('Name')) {
            $oidPart2 = ($Name -split '\.')[0]
            do {
                $oidPart1 = Get-Random -Minimum 10000000 -Maximum 99999999

                $msPKICertTemplateOID = "$forestOID.$oidPart1.$oidPart2"
            } until (Test-IsUniqueOID @common -Name $Name -TemplateOID $msPKICertTemplateOID)
        }
        else {
            do {
                $oidPart1 = Get-Random -Minimum 10000000 -Maximum 99999999
                $oidPart2 = Get-Random -Minimum 10000000 -Maximum 99999999
                $oidPart3 = Get-RandomHex -Length 32

                $msPKICertTemplateOID = "$forestOID.$oidPart1.$oidPart2"
                $Name = "$oidPart2.$oidPart3"

            } until (Test-IsUniqueOID @common -Name $Name -TemplateOID $msPKICertTemplateOID)
        }

        $oid = [PSCustomObject]@{
            Name        = $Name
            TemplateOID = $msPKICertTemplateOID
        }

        Write-Output -InputObject $oid
    }
}
