<#
.SYNOPSIS
Removes an ADCS issuance policy from Active Directory.

.DESCRIPTION
This function removes an ADCS (Active Directory Certificate Services) issuance policy based on the specified policy name, display name, or input object.

.PARAMETER Name
Specifies the name of the ADCS issuance policy to remove.

.PARAMETER DisplayName
Specifies the display name of the ADCS issuance policy to remove.

.PARAMETER InputObject
Specifies the input object representing the ADCS issuance policy to remove.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, the default server is used.

.OUTPUTS
System.Void

.EXAMPLE
Remove-ADCSIssuancePolicy -Name "402.605C2ADE38A9344C83FA715663DB8821"

Removes the issuance policy with the specified Name using the default domain controller.

.EXAMPLE
Remove-ADCSIssuancePolicy -DisplayName "Policy Display Name"

Removes the issuance policy with the specified DisplayName using the default domain controller.
#>
function Remove-ADCSIssuancePolicy {
    [CmdletBinding(
        DefaultParameterSetName = 'Name',
        ConfirmImpact = 'High',
        SupportsShouldProcess = $true
    )]
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
        [PSTypeName('ADCSIssuancePolicy')]$InputObject,

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

        $templates = Get-ADCSTemplate @common
    }

    process {
        $params = @{}
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            $policyName = $Name
            $params.Name = $Name
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'DisplayName') {
            $policyName = $DisplayName
            $params.DisplayName = $DisplayName
        }
        elseif ($PSBoundParameters.ContainsKey('InputObject')) {
            $policyName = $InputObject.Name
            $params.Name = $InputObject.Name
        }

        $policies = Get-ADCSIssuancePolicy @Common @params -Properties Name, DistinguishedName, 'msPKI-Cert-Template-OID'

        foreach ($policy in $policies) {
            $oid = $policy.'msPKI-Cert-Template-OID'
            $activeTemplates = $templates | Where-Object {
                $_.'msPKI-Certificate-Policy'.Contains($oid) -or
                $_.'msPKI-RA-Policies'.Contains($oid)
            }

            if ($activeTemplates) {
                $templatesNames = ($activeTemplates | Select-Object -ExpandProperty Name) -join ','

                $errorRecord = New-ADCSIssuancePolicyInvalidOperationException -Message "Issuance Policy '$policyName' is in use by the following certificate templates: $templatesNames."
                $PSCmdlet.ThrowTerminatingError($errorRecord)
            }

            if ($PSCmdlet.ShouldProcess($policy.Name, 'Remove issuance policy')) {
                Remove-ADObject @common -Identity $policy.DistinguishedName -Confirm:$false
            }
        }
    }
}