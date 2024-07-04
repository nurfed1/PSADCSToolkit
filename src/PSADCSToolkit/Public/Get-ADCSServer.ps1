<#
.SYNOPSIS
Retrieves ADCS (Active Directory Certificate Services) server information.

.DESCRIPTION
Retrieves information about ADCS servers. Allows filtering by server name and can target a specific Active Directory server for the query.

.PARAMETER Name
Specifies the name of the ADCS server to retrieve. If not provided, all ADCS servers are retrieved.

.PARAMETER Properties
Specifies specific properties of the ADCS server to retrieve.
Defaults to all properties defined in the ADCSServerPropertyMap.

.PARAMETER Server
Specifies the Active Directory server to connect to for retrieving ADCS server information. If not provided, the default server is used.

.OUTPUTS
PSCustomObject with type 'ADCSServer'.

.EXAMPLE
PS C:\> Get-ADCSServer -Server "dc01.domain.com"

Retrieves information about all ADCS servers from the specified Active Directory server "dc01.domain.com".

.EXAMPLE
PS C:\> Get-ADCSServer -Name "Root CA"

Retrieves information about the ADCS server named "Root CA".
#>
Function Get-ADCSServer {
    [CmdletBinding()]
    [OutputType('ADCSServer')]
    param(
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [System.String]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [PSDefaultValue(Help = 'All Properties')]
        [System.String[]]$Properties = ($script:ADCSServerPropertyMap | Select-Object -ExpandProperty Name),

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

        $defaultParameters = $script:ADCSServerPropertyMap | Where-Object -FilterScript { $_.Mandatory -eq $true } | Select-Object -ExpandProperty Name
        $requestProperties = [string[]]($defaultParameters + $Properties)

        # Filter unique values with a twist... powershell is not exactly consistent with case insensitity.
        $requestProperties = [string[]][System.Linq.Enumerable]::Distinct($requestProperties, [System.StringComparer]::OrdinalIgnoreCase)
        # $requestProperties = $defaultParameters + $Properties | Select-Object -Unique

        $configNC = (Get-ADRootDSE @common).configurationNamingContext
        $certAuthorityPath = "CN=Certification Authorities,CN=Public Key Services,CN=Services,$configNC"
        # Using AIA, Certification Authorities only lists Root CA's
        $AIAPath = "CN=AIA,CN=Public Key Services,CN=Services,$configNC"
    }

    process {
        $requestAll = $false
        if ($PSBoundParameters.ContainsKey('Name')) {
            $ldapFilter = "(&(objectClass=certificationAuthority)(name=$Name))"
        }
        else {
            $ldapFilter = '(objectClass=certificationAuthority)'
            $requestAll = $true
        }

        $objects = Get-ADObject @common -SearchScope Subtree -SearchBase $AIAPath -LDAPFilter $ldapFilter -Properties $requestProperties
        if (-not $requestAll -and -not $objects) {
            $errorRecord = New-ADCSServerNotFoundException -Message "ADCS Server '$Name' does not exist."
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

            $certAuthority = [PSCustomObject]@{
                PSTypeName = "ADCSServer"
            }

            $exportProperties | ForEach-Object {
                $propertyName = $_
                $propertyValue = $object.$propertyName

                # Transform known properties to the correct type
                # ADPropertyValueCollection causes issues in some functions
                $typeInfo = $script:ADCSServerPropertyMap | Where-Object -FilterScript { $_.Name -eq $propertyName } | Select-Object -ExpandProperty Type
                if ($typeInfo) {
                    $propertyValue = ($propertyValue -as $typeInfo)
                }

                $certAuthority | Add-Member -Type NoteProperty -Name $propertyName -Value $propertyValue
            }

            # Custom property to check if root CA
            # CA's listed in certAuthorityPath are root CA's
            $ldapFilter = "(&(objectClass=certificationAuthority)(name=$($object.Name)))"
            if (Get-ADObject @common -SearchScope Subtree -SearchBase $certAuthorityPath -LDAPFilter $ldapFilter) {
                $certAuthority | Add-Member -Type NoteProperty -Name "IsRootCA" -Value $true
            } else {
                $certAuthority | Add-Member -Type NoteProperty -Name "IsRootCA" -Value $false
            }

            Write-Output -InputObject $certAuthority
        }
    }
}

$PropertiesArgumentCompleter = {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Command')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Parameter')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CommandAst')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'FakeBoundParams')]
    param ($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

    $script:ADCSServerPropertyMap | select-Object -ExpandProperty Name | Where-Object { $_ -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName "Get-ADCSServer" -ParameterName "Properties" -ScriptBlock $PropertiesArgumentCompleter
