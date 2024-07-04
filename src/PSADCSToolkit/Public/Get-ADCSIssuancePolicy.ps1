<#
.SYNOPSIS
Retrieves ADCS (Active Directory Certificate Services) issuance policies.

.DESCRIPTION
Retrieves ADCS issuance policies based on name, display name, OID, or input object.
Optionally, specific properties can be requested, and a specific server can be targeted.

.PARAMETER Name
Specifies the name of the ADCS issuance policy to retrieve.

.PARAMETER DisplayName
Specifies the display name of the ADCS issuance policy to retrieve.

.PARAMETER Oid
Specifies the OID of the ADCS issuance policy to retrieve.

.PARAMETER InputObject
Specifies an ADCSIssuancePolicy object from which to retrieve properties.

.PARAMETER Properties
Specifies specific properties of the ADCS issuance policy to retrieve.
Defaults to all properties defined in the ADCSIssuancePolicyPropertyMap.

.PARAMETER Server
Specifies the server to connect to for retrieving ADCS information.

.OUTPUTS
PSCustomObject with type 'ADCSIssuancePolicy'.

.EXAMPLE
PS C:\> Get-ADCSIssuancePolicy

Retrieves all ADCS issuance policies.

.EXAMPLE
PS C:\> Get-ADCSIssuancePolicy -Name "PolicyName"

Retrieves the ADCS issuance policy with the name "PolicyName".

.EXAMPLE
PS C:\> Get-ADCSIssuancePolicy -DisplayName "Policy Display Name"

Retrieves the ADCS issuance policy with the display name "Policy Display Name".

.EXAMPLE
PS C:\> Get-ADCSIssuancePolicy -Oid "1.3.6.1.4.1.311.21.8.2367620.13778790.8537997.8704753.4613409.108.69759536.19157042"

Retrieves the ADCS issuance policy with the OID "1.3.6.1.4.1.311.21.8.2367620.13778790.8537997.8704753.4613409.108.69759536.19157042".
#>
function Get-ADCSIssuancePolicy {
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    [OutputType('ADCSIssuancePolicy')]
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
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Oid'
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [System.String]$Oid,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'InputObject'
        )]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('ADCSIssuancePolicy')]$InputObject,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [PSDefaultValue(Help = 'All Properties')]
        [System.String[]]$Properties = ($script:ADCSIssuancePolicyPropertyMap | select-Object -ExpandProperty Name),

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

        $defaultParameters = $script:ADCSIssuancePolicyPropertyMap | Where-Object -FilterScript { $_.Mandatory -eq $true } | Select-Object -ExpandProperty Name
        $requestProperties = [string[]]($defaultParameters + $Properties)

        # Filter unique values with a twist... powershell is not exactly consistent with case insensitity.
        $requestProperties = [string[]][System.Linq.Enumerable]::Distinct($requestProperties, [System.StringComparer]::OrdinalIgnoreCase)
        # $requestProperties = $defaultParameters + $Properties | Select-Object -Unique

        $configNC = (Get-ADRootDSE @common).configurationNamingContext
        $policyPath = "CN=OID,CN=Public Key Services,CN=Services,$configNC"
    }

    process {
        $requestAll = $false
        if ($PSBoundParameters.ContainsKey('Name')) {
            $policyName = $Name
            $ldapFilter = "(&(objectClass=msPKI-Enterprise-Oid)(flags=2)(name=$Name))"
        }
        elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
            $policyName = $DisplayName
            $ldapFilter = "(&(objectClass=msPKI-Enterprise-Oid)(flags=2)(displayName=$DisplayName))"
        }
        elseif ($PSBoundParameters.ContainsKey('Oid')) {
            $policyName = $Oid
            $ldapFilter = "(&(objectClass=msPKI-Enterprise-Oid)(flags=2)(msPKI-Cert-Template-OID=$Oid))"
        }
        elseif ($PSBoundParameters.ContainsKey('InputObject')) {
            $policyName = $InputObject.Name
            $ldapFilter = "(&(objectClass=msPKI-Enterprise-Oid)(flags=2)(name=$policyName))"
        }
        else {
            $ldapFilter = '(&(objectClass=msPKI-Enterprise-Oid)(flags=2))'
            $requestAll = $true
        }

        $objects = Get-ADObject @common -SearchScope OneLevel -SearchBase $policyPath -LDAPFilter $ldapFilter -Properties $requestProperties
        if (-not $requestAll -and -not $objects) {
            $errorRecord = New-ADCSIssuancePolicyNotFoundException -Message "Issuance Policy '$policyName' does not exist."
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

            $policy = [PSCustomObject]@{
                PSTypeName = "ADCSIssuancePolicy"
            }

            # Only export requested and default properties
            $exportProperties | ForEach-Object {
                $propertyName = $_
                $propertyValue = $object.$propertyName

                # Transform known properties to the correct type
                # ADPropertyValueCollection causes issues in some functions
                $typeInfo = $script:ADCSIssuancePolicyPropertyMap | Where-Object -FilterScript { $_.Name -eq $propertyName } | Select-Object -ExpandProperty Type
                if ($typeInfo) {
                    $propertyValue = ($propertyValue -as $typeInfo)
                }

                $policy | Add-Member -Type NoteProperty -Name $propertyName -Value $propertyValue
            }

            Write-Output -InputObject $policy
        }
    }
}

$PropertiesArgumentCompleter = {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Command')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Parameter')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'CommandAst')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'FakeBoundParams')]
    param ($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

    $script:ADCSIssuancePolicyPropertyMap | select-Object -ExpandProperty Name | Where-Object { $_ -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName "Get-ADCSIssuancePolicy" -ParameterName "Properties" -ScriptBlock $PropertiesArgumentCompleter
