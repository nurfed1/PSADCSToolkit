<#
.SYNOPSIS
Retrieves the enrollment services associated with an ADCS certificate template.

.DESCRIPTION
The `Get-ADCSTemplateEnrollmentService` function retrieves Active Directory Certificate Services (ADCS) enrollment services that are associated with a specified certificate template.
You can search by template name, display name, or provide an existing `ADCSTemplate` object.

.PARAMETER Name
Specifies the name of the ADCS certificate template(s) for which to retrieve associated enrollment services.
Supports wildcards.

.PARAMETER DisplayName
Specifies the display name of the ADCS certificate template(s) for which to retrieve associated enrollment services.
Supports wildcards.

.PARAMETER InputObject
Specifies an `ADCSTemplate` object. Enrollment services associated with the provided template object will be retrieved.

.PARAMETER Server
Specifies the ADCS server to query for template enrollment services.

.OUTPUTS
PSCustomObject with type 'ADCSTemplateEnrollmentService'.

.EXAMPLE
PS C:\> Get-ADCSTemplateEnrollmentService -Name "WebServer"

Retrieves the enrollment services associated with the ADCS certificate template named "WebServer".

.EXAMPLE
PS C:\> Get-ADCSTemplateEnrollmentService -DisplayName "Web Server Authentication"

Retrieves the enrollment services associated with the ADCS certificate template that has the display name "Web Server Authentication".

.EXAMPLE
PS C:\> Get-ADCSTemplate -Name "WebServer" | Get-ADCSTemplateEnrollmentService

Retrieves the enrollment services for the "WebServer" template by piping the result of `Get-ADCSTemplate` into `Get-ADCSTemplateEnrollmentService`.

.EXAMPLE
PS C:\> Get-ADCSTemplateEnrollmentService -Name "User" -Server "CA01"

Retrieves the enrollment services associated with the "User" ADCS certificate template from the specified CA server "CA01".

#>
Function Get-ADCSTemplateEnrollmentService {
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    [OutputType('ADCSTemplateEnrollmentService')]
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
        [ValidateNotNullOrEmpty()]
        [PSTypeName('ADCSTemplate')]$InputObject,

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

        $enrollmentServices = Get-ADCSEnrollmentService @common
    }

    process {
        if ($PSBoundParameters.ContainsKey('Name')) {
            $templates = Get-ADCSTemplate @common -Name $Name -Properties Name, DistinguishedName
        }
        elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
            $templates = Get-ADCSTemplate @common -DisplayName $DisplayName -Properties Name, DistinguishedName
        }
        elseif ($PSBoundParameters.ContainsKey('InputObject')) {
            $templates = $InputObject
        }

        foreach ($template in $templates) {
            $templateenrollmentServices = $enrollmentServices | Where-Object -FilterScript { $_.certificateTemplates -eq $template.Name } | Select-Object -ExpandProperty Name

            $object = [PSCustomObject]@{
                PSTypeName              = "ADCSTemplateEnrollmentService"
                TemplateName            = $template.Name
                enrollmentServices       = $templateenrollmentServices
            }

            Write-Output -InputObject $object
        }
    }
}
