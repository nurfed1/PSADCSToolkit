<#
.SYNOPSIS
Retrieves Active Directory Certificate Services (ADCS) certificate templates.

.DESCRIPTION
Retrieves ADCS certificate templates based on name, display name, or input object.

.PARAMETER Name
Specifies the name of the ADCS certificate template(s) to retrieve.

.PARAMETER DisplayName
Specifies the display name of the ADCS certificate template(s) to retrieve.

.PARAMETER InputObject
Specifies an ADCSTemplate object from which to retrieve properties.

.PARAMETER Properties
Specifies specific properties of the ADCS certificate template to retrieve.
Defaults to all properties defined in the ADCSTemplatePropertyMap.

.PARAMETER Server
Specifies the server to connect to for retrieving ADCS information.

.OUTPUTS
PSCustomObject with type 'ADCSTemplate'.

.EXAMPLE
PS C:\> Get-ADCSTemplate

Retrieves all ADCS certificate templates.

.EXAMPLE
PS C:\> Get-ADCSTemplate -Name "WebServer"

Retrieves the ADCS certificate template with the name "WebServer".

.EXAMPLE
PS C:\> Get-ADCSTemplate -DisplayName "Web Server Authentication"

Retrieves the ADCS certificate template with the display name "Web Server Authentication".

.EXAMPLE
PS C:\> Get-ADCSTemplate -Properties Name, Created, Modified | Sort-Object Name | ft

Retrieves the Created and Modified properties of all ADCS certificate templates.
#>
function Get-ADCSTemplate {
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    [OutputType('ADCSTemplate')]
    param(
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Name'
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [System.String]$Name,

        [Parameter(
            Mandatory = $false,
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
        [SupportsWildcards()]
        [PSDefaultValue(Help = 'All Properties')]
        [System.String[]]$Properties = ($script:ADCSTemplatePropertyMap | Select-Object -ExpandProperty ADProperty),

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

        $defaultParameters = $script:ADCSTemplatePropertyMap | Where-Object -FilterScript { $_.Mandatory -eq $true } | Select-Object -ExpandProperty ADProperty
        $requestProperties = [System.String[]]($defaultParameters + $Properties)

        # Filter unique values with a twist... powershell is not exactly consistent with case insensitity.
        $requestProperties = [System.String[]][System.Linq.Enumerable]::Distinct($requestProperties, [System.StringComparer]::OrdinalIgnoreCase)
        # $requestProperties = $defaultParameters + $Properties | Select-Object -Unique

        $configNC = (Get-ADRootDSE @common).configurationNamingContext
        $templatePath = "CN=Certificate Templates,CN=Public Key Services,CN=Services,$configNC"
    }

    process {
        $requestAll = $false
        if ($PSBoundParameters.ContainsKey('Name')) {
            $templateName = $Name
            $ldapFilter = "(&(objectClass=pKICertificateTemplate)(name=$Name))"
        }
        elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
            $templateName = $DisplayName
            $ldapFilter = "(&(objectClass=pKICertificateTemplate)(displayName=$DisplayName))"
        }
        elseif ($PSBoundParameters.ContainsKey('InputObject')) {
            $templateName = $InputObject.Name
            $ldapFilter = "(&(objectClass=pKICertificateTemplate)(name=$templateName))"
        }
        else {
            $ldapFilter = "(objectClass=pKICertificateTemplate)"
            $requestAll = $true
        }

        $objects = Get-ADObject @common -SearchScope OneLevel -SearchBase $templatePath -LDAPFilter $ldapFilter -Properties $requestProperties
        if (-not $requestAll -and -not $objects) {
            $errorRecord = New-ADCSTemplateNotFoundException -Message "Template '$templateName' does not exist."
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        foreach ($object in $objects) {
            if ($requestProperties.Contains('*')) {
                # Grab all properties
                $exportProperties = $object.PSObject.Properties | Select-Object -ExpandProperty Name
            }
            else {
                $exportProperties = $requestProperties
            }

            $template = [PSCustomObject]@{
                PSTypeName = "ADCSTemplate"
            }

            # Only export requested and default properties
            $exportProperties | ForEach-Object {
                $ADPropertyName = $_
                $ADPropertyValue = $object.$ADPropertyName

                $propertyInfo = $script:ADCSTemplatePropertyMap | Where-Object -FilterScript { $_.ADProperty -eq $ADPropertyName }
                if ($null -ne $propertyInfo) {
                    # if type info available, cast to AD Type
                    $ADPropertyValue = ($ADPropertyValue -as $propertyInfo.ADType)
                }

                $template | Add-Member -Type NoteProperty -Name $ADPropertyName -Value $ADPropertyValue
            }

            Write-Output -InputObject $template
        }
    }
}

$propertiesArgumentCompleter = {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Command')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Parameter')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CommandAst')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'FakeBoundParams')]
    param ($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

    $script:ADCSTemplatePropertyMap | Select-Object -ExpandProperty ADProperty | Where-Object { $_ -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName "Get-ADCSTemplate" -ParameterName "Properties" -ScriptBlock $propertiesArgumentCompleter
