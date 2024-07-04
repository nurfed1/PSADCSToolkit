<#
.SYNOPSIS
Retrieves information about ADCS (Active Directory Certificate Services) Enrollment Servers.

.DESCRIPTION
This function retrieves information about ADCS Enrollment Servers from Active Directory. You can filter the results by Name or DisplayName, and specify a particular Active Directory server to query.

.PARAMETER Name
Specifies the name of the ADCS Enrollment Server to retrieve.

.PARAMETER DisplayName
Specifies the display name of the ADCS Enrollment Server to retrieve.

.PARAMETER Server
Specifies the Active Directory server to connect to for retrieving ADCS Enrollment Server information.

.PARAMETER Properties
Specifies specific properties of the ADCS enrollment service to retrieve.
Defaults to all properties defined in the ADCSTemplatePropertyMap.

.OUTPUTS
PSCustomObject with type 'ADCSEnrollmentService'.

.EXAMPLE
PS C:\> Get-ADCSEnrollmentService -Server "dc01.domain.com"

Retrieves information about all ADCS Enrollment Servers from the specified Active Directory server "dc01.domain.com".

.EXAMPLE
PS C:\> Get-ADCSEnrollmentService -Name "Issuing CA"

Retrieves information about the ADCS Enrollment Server named "Issuing CA".

.EXAMPLE
PS C:\> Get-ADCSEnrollmentService -DisplayName "Issuing CA"

Retrieves information about the ADCS Enrollment Server with the display name "Issuing CA".
#>
Function Get-ADCSEnrollmentService {
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    [OutputType('ADCSEnrollmentService')]
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

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [PSDefaultValue(Help = 'All Properties')]
        [System.String[]]$Properties = ($script:ADCSEnrollmentServicePropertyMap | Select-Object -ExpandProperty Name),

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

        $defaultParameters = $script:ADCSEnrollmentServicePropertyMap | Where-Object -FilterScript { $_.Mandatory -eq $true } | Select-Object -ExpandProperty Name
        $requestProperties = [string[]]($defaultParameters + $Properties)

        # Filter unique values with a twist... powershell is not exactly consistent with case insensitity.
        $requestProperties = [string[]][System.Linq.Enumerable]::Distinct($requestProperties, [System.StringComparer]::OrdinalIgnoreCase)
        # $requestProperties = $defaultParameters + $Properties | Select-Object -Unique

        $configNC = (Get-ADRootDSE @common).configurationNamingContext
        $enrollmentServicePath = "CN=Enrollment Services,CN=Public Key Services,CN=Services,$configNC"
    }

    process {
        $requestAll = $false
        if ($PSBoundParameters.ContainsKey('Name')) {
            $serverName = $Name
            $LDAPFilter = "(&(objectClass=pKIEnrollmentService)(name=$Name))"
        }
        elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
            $serverName = $DisplayName
            $LDAPFilter = "(&(objectClass=pKIEnrollmentService)(displayName=$DisplayName))"
        }
        else {
            $LDAPFilter = '(objectClass=pKIEnrollmentService)'
            $requestAll = $true
        }

        $objects = Get-ADObject @common -SearchScope Subtree -SearchBase $EnrollmentServicePath -LDAPFilter $LDAPFilter -Properties $requestProperties
        if (-not $requestAll -and -not $objects) {
            $errorRecord = New-ADCSEnrollmentServiceNotFoundException -Message "ADCS Enrollment Server '$serverName' does not exist."
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

            $enrollmentService = [PSCustomObject]@{
                PSTypeName = "ADCSEnrollmentService"
            }

            $exportProperties | ForEach-Object {
                $propertyName = $_
                $propertyValue = $object.$propertyName

                # Transform known properties to the correct type
                # ADPropertyValueCollection causes issues in some functions
                $typeInfo = $script:ADCSEnrollmentServicePropertyMap | Where-Object -FilterScript { $_.Name -eq $propertyName } | Select-Object -ExpandProperty Type
                if ($typeInfo) {
                    $propertyValue = ($propertyValue -as $typeInfo)
                }

                $enrollmentService | Add-Member -Type NoteProperty -Name $propertyName -Value $propertyValue
            }

            Write-Output -InputObject $enrollmentService
        }
    }
}

$PropertiesArgumentCompleter = {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Command')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Parameter')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CommandAst')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'FakeBoundParams')]
    param ($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

    $script:ADCSEnrollmentServicePropertyMap | select-Object -ExpandProperty Name | Where-Object { $_ -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName "Get-ADCSEnrollmentService" -ParameterName "Properties" -ScriptBlock $PropertiesArgumentCompleter
