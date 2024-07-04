<#
.SYNOPSIS
Removes certificate templates from Active Directory Certificate Services (ADCS).

.DESCRIPTION
This function removes the specified certificate templates from Active Directory, including unpublishing them from all
certificate authorities (CAs) and deleting the associated OID.

.PARAMETER Name
Specifies the name of the certificate template(s) to be removed.

.PARAMETER InputObject
Specifies the certificate template object(s) to be removed.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, the default server is used.

.OUTPUTS
System.Void

.EXAMPLE
PS C:\> Remove-ADCSTemplate -DisplayName User

Removes the certificate template named "User" from Active Directory.
#>
function Remove-ADCSTemplate {
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

        $configNC = (Get-ADRootDSE @common).configurationNamingContext
        $templateOIDPath = "CN=OID,CN=Public Key Services,CN=Services,$configNC"
    }

    process {
        if ($PSBoundParameters.ContainsKey('InputObject')) {
            $Name = $InputObject.Name
        }

        # Ensure msPKI-Cert-Template-OID is retrieved.
        $templates = Get-ADCSTemplate @common -Name $Name -Properties Name, DistinguishedName, 'msPKI-Cert-Template-OID'

        foreach ($template in $templates) {
            if ($PSCmdlet.ShouldProcess($template.Name, "Remove certificate template")) {
                # Unpublish from Certificate Authorities
                Unpublish-ADCSTemplate @common -Name $template.Name

                # Remove the template itself
                Remove-ADObject @common -Identity $template.DistinguishedName -Confirm:$false

                # Remove the OID associated with the template
                $templateOID = $template.'msPKI-Cert-Template-OID'
                Get-ADObject @common -SearchBase $templateOIDPath -Filter { msPKI-Cert-Template-OID -eq $templateOID } | Remove-ADObject @common -Confirm:$false
            }
        }
    }
}