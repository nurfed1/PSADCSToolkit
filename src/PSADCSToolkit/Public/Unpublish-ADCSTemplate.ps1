<#
.SYNOPSIS
Unpublishes certificate templates from specified or all Active Directory Certificate Services (ADCS) enrollment service.

.DESCRIPTION
This function removes the specified certificate templates from the list of templates that are published on the specified
ADCS enrollment services. If no enrollment services are specified, the templates are unpublished from all available
enrollment services.

.PARAMETER Name
Specifies the name of the certificate template(s) to be unpublished.

.PARAMETER InputObject
Specifies the certificate template object(s) to be unpublished.

.PARAMETER EnrollmentServices
Specifies the ADCS enrollment service from which to unpublish the certificate templates. If not specified, the function
will unpublish the templates from all available enrollment service.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, uses the default server.

.OUTPUTS
System.Void

.EXAMPLE
PS C:\> Unpublish-ADCSTemplate -Name "User"

This example unpublishes the certificate template named "User" from all enrollment services.

.EXAMPLE
PS C:\> Unpublish-ADCSTemplate -Name "User" -EnrollmentServices "Issuing CA"

This example unpublishes the certificate template named "User" from the specified enrollment service.
#>
Function Unpublish-ADCSTemplate {
    [CmdletBinding(DefaultParameterSetName = 'Name', SupportsShouldProcess = $true)]
    [OutputType([System.Void])]
    param (
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
                Set-ADObject @common -Identity $certAuthority.DistinguishedName -Remove @{ certificateTemplates = $templateNames } -Confirm:$false
            }
        }
    }
}