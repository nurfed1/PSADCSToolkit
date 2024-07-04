@{
    Properties = @(
        <#
        Import: Properties that should be imported.
        Mandatory: Properties that should be always returned in an object
        #>
        [PSCustomObject]@{
            Name    = 'Name'
            Type    = [System.String]
            Import  = $false
            Mandatory = $true
        }
        [PSCustomObject]@{
            Name    = 'DistinguishedName'
            Type    = [System.String]
            Import  = $false
            Mandatory = $true
        }
        [PSCustomObject]@{
            Name    = 'DisplayName'
            Type    = [System.String]
            Import  = $true
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'flags'
            Type    = [System.Int32]
            Import  = $false
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'msDS-OIDToGroupLink'
            Type    = [System.String]
            Import  = $true
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'msPKI-Cert-Template-OID'
            Type    = [System.String]
            Import  = $false
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'msPKI-OID-Attribute'
            Type    = [System.Int32]
            Import  = $true
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'msPKI-OID-CPS'
            Type    = [System.String[]]
            Import  = $true
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'msPKI-OIDLocalizedName'
            Type    = [System.String[]]
            Import  = $true
            Mandatory = $false
        }

        [PSCustomObject]@{
            Name    = 'msPKI-OID-User-Notice'
            Type    = [System.String[]]
            Import  = $true
            Mandatory = $false
        }
    )
}
