@{
    Properties = @(
        <#
        Import: Properties that should be imported.
        Mandatory: Properties that should be always returned in an object
        #>
        [PSCustomObject]@{
            Name    = 'Name'
            Type    = [System.String]
            Mandatory = $true
        }
        [PSCustomObject]@{
            Name    = 'DistinguishedName'
            Type    = [System.String]
            Mandatory = $true
        }
        [PSCustomObject]@{
            Name    = 'DisplayName'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'cACertificate'
            Type    = [System.Security.Cryptography.X509Certificates.X509Certificate2[]] #[System.Byte[][]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'cACertificateDN'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'certificateTemplates'
            Type    = [System.String[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'dNSHostName'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'enrollmentProviders'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'msPKI-Enrollment-Servers'
            Type    = [System.String[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'msPKI-Site-Name'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'signatureAlgorithms'
            Type    = [System.String]
            Mandatory = $false
        }
    )
}
