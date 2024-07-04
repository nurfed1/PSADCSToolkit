<#
.SYNOPSIS
Creates a PSDrive for accessing Active Directory Certificate Services (ADCS) configuration.

.DESCRIPTION
This function creates a PSDrive named 'ADCS' to facilitate navigation and management of ADCS configuration
settings in Active Directory. It imports the ActiveDirectory module and sets up the drive under the
'CN=Public Key Services,CN=Services' container in the ADCS configuration context.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, uses the default server.

.OUTPUTS
Microsoft.ActiveDirectory.Management.Provider.ADDriveInfo
Returns the new PSDrive object.

.EXAMPLE
PS C:\> New-ADCSDrive
PS C:\> Get-PSDrive
PS C:\> cd ADCS:

Navigates to the ADCS: drive.
#>
Function New-ADCSDrive {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([Microsoft.ActiveDirectory.Management.Provider.ADDriveInfo])]
    param(
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

        Import-Module ActiveDirectory -Verbose:$false

        $configNC = $((Get-ADRootDSE @common).configurationNamingContext)

        if ($PSCmdlet.ShouldProcess("Creating ADCS PSDrive", "Adding a new Active Directory drive")) {
            # This is bugged for w/e reason and doesn't allow tab completation
            # New-PSDrive @common -Name ADCS -PSProvider ActiveDirectory -Root "CN=Public Key Services,CN=Services,$configNC" -Scope Global

            # Workaround
            New-PSDrive @common -Name ADCS -PSProvider ActiveDirectory -Root "" -Scope Global
            Push-Location -Path "ADCS:"
            Set-Location -Path "CN=Public Key Services,CN=Services,$configNC"
            Pop-Location
        }
    }
}
