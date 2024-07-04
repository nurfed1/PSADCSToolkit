<#
.SYNOPSIS
Publishes certificate templates to specified or all Active Directory Certificate Services (ADCS) enrollment services.

.DESCRIPTION
This function adds the specified certificate templates to the list of templates that are published on the specified
ADCS enrollment services. If no enrollment services are specified, the templates are published on all available
enrollment services.

.PARAMETER Name
Specifies the name of the certificate template(s) to be published.

.PARAMETER InputObject
Specifies the certificate template object(s) to be published.

.PARAMETER EnrollmentServices
Specifies the ADCS enrollment services to which the certificate templates will be published. If not specified, the
function will publish the templates to all available enrollment services.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, the default server is used.

.OUTPUTS
System.Void

.EXAMPLE
PS C:\> Publish-ADCSTemplate -Name "User"

This example publishes the certificate template named "User" to all enrollment services.

.EXAMPLE
PS C:\> Publish-ADCSTemplate -Name "User" -EnrollmentServices "Issuing CA"

This example publishes the certificate template named "User" to the specified enrollment services.
#>
Function Publish-ADCSTemplate {
    [CmdletBinding(DefaultParameterSetName = 'Name', SupportsShouldProcess = $true)]
    [OutputType([System.Void])]
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
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'InputObject'
        )]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('ADCSTemplate')]$InputObject,

        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$EnrollmentServices,

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

        $certAuthorities = [System.Collections.ArrayList]@()
        if ($PSBoundParameters.ContainsKey('EnrollmentServices')) {
            foreach ($EnrollmentService in $EnrollmentServices) {
                $certAuthority = Get-ADCSEnrollmentService @common -Name $EnrollmentService

                $certAuthorities.Add($certAuthority) | Out-Null
            }
        }
        else {
            Get-ADCSEnrollmentService @common | ForEach-Object {
                $certAuthorities.Add($_) | Out-Null
            }
        }
    }

    process {
        if ($PSBoundParameters.ContainsKey('Name')) {
            $templates = Get-ADCSTemplate @common -Name $Name -Properties Name, DistinguishedName
        }
        elseif ($PSBoundParameters.ContainsKey('InputObject')) {
            $templates = $InputObject
        }

        foreach ($certAuthority in $certAuthorities) {
            [System.String[]]$templateNames = $templates | Select-Object -ExpandProperty Name
            if ($PSCmdlet.ShouldProcess($certAuthority.Name, "Unpublishing certificate templates '$($templateNames -join ',')'")) {
                Set-ADObject @common -Identity $certAuthority.DistinguishedName -Add @{ certificateTemplates = $templateNames }
            }
        }
    }
}
