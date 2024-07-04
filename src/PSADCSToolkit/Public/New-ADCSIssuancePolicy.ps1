<#
.SYNOPSIS
Creates a new ADCS issuance policy in Active Directory.

.DESCRIPTION
This function creates a new ADCS (Active Directory Certificate Services) issuance policy based on the provided parameters.
It supports creating policies either by specifying a policy name or display name and a JSON configuration or an input object.

.PARAMETER Name
Specifies the OID (Object Identifier) of the ADCS issuance policy.
The name should match the pattern '^\d+\.[0-9a-fA-F]{32}$'.

.PARAMETER DisplayName
Specifies the display name of the ADCS issuance policy.

.PARAMETER Json
Specifies the JSON representation of the ADCS issuance policy configuration.

.PARAMETER InputObject
Specifies the input object representing the ADCS issuance policy configuration.

.PARAMETER PassThru
Indicates that the created ADCS issuance policy object should be passed through the pipeline.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, the default server is used.

.OUTPUTS
PSCustomObject with type 'ADCSIssuancePolicy' - if the passthru parameter is set.

.EXAMPLE
PS C:\> New-ADCSIssuancePolicy -Name "402.605C2ADE38A9344C83FA715663DB8821" -Json (Get-Content policy.Json -Raw)

Creates a new issuance policy with the specified Name  and the provided JSON data.

.EXAMPLE
New-ADCSIssuancePolicy -DisplayName "Policy Name" -Json (Export-ADCSIssuancePolicy -Name SomePolicy)

Creates a new issuance policy with the specified DisplayName and the provided JSON data.
#>
Function New-ADCSIssuancePolicy {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingEmptyCatchBlock", "")]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'NameJson')]
    [OutputType('ADCSIssuancePolicy')]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'NameJson'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'NameInput'
        )]
        [ValidatePattern('^\d+\.[0-9a-fA-F]{32}$')]
        [System.String]$Name,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'DisplayNameJson'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'DisplayNameInput'
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]$DisplayName,

        [Parameter(Mandatory = $true, ParameterSetName = 'NameJson')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DisplayNameJson')]
        [ValidateNotNullOrEmpty()]
        [System.String]$Json,

        [Parameter(Mandatory = $true, ParameterSetName = 'NameInput')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DisplayNameInput')]
        [ValidateNotNullOrEmpty()]
        [System.Object]$InputObject,

        [Parameter(Mandatory = $false)]
        [switch]$PassThru = $false,

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

        $params = @{}
        if ($PSBoundParameters.ContainsKey('Name')) {
            $params.Name = $Name
        }
        elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
            $params.DisplayName = $DisplayName
        }

        try {
            Get-ADCSIssuancePolicy @common @params | Out-Null

            # Policy exists if this succeeds
            $errorRecord = New-ADCSIssuancePolicyAlreadyExistsException -Message "The specified issuance policy already exists."
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        } catch [ADCSIssuancePolicyNotFoundException] {
            # Nothing to do here
        } catch {
            $errorRecord = $_
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }


        if ($PSBoundParameters.ContainsKey('Json')) {
            $InputObject = $Json | ConvertFrom-Json
        }

        if ($PSBoundParameters.ContainsKey('Name')) {
            $oid = New-EnterpriseOID @common -Name $Name
            $policyName = $Name
        }
        elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
            $InputObject.displayName = $DisplayName
            $oid = New-EnterpriseOID @common
            $policyName = $DisplayName
        }

        $otherAttributes = @{
            'flags'                   = [System.Int32]2
            'msPKI-Cert-Template-OID' = $oid.TemplateOID
        }

        foreach ($property in ($script:ADCSIssuancePolicyPropertyMap | Where-Object { $_.Import -eq $true })) {
            $propertyName = $property.Name
            $propertyType = $property.Type

            if (($propertyName -in $InputObject.PSobject.Properties.name) -and
                (-not [string]::IsNullOrEmpty($InputObject.$propertyName))) {

                $inputValue = ($InputObject.$propertyName -as $propertyType)
                $otherAttributes.Add($propertyName, $inputValue)
            }
        }

        $configNC = (Get-ADRootDSE @common).configurationNamingContext
        $policyPath = "CN=OID,CN=Public Key Services,CN=Services,$configNC"

        if ($PSCmdlet.ShouldProcess($policyPath, "Creating issuance policy '$policyName")) {
            New-ADObject @common -Path $policyPath -OtherAttributes $otherAttributes -Name $oid.Name -Type 'msPKI-Enterprise-Oid'

            if ($PassThru) {
                Write-Output -InputObject (Get-ADCSIssuancePolicy @common -Name $oid.Name)
            }
        }
    }
}
