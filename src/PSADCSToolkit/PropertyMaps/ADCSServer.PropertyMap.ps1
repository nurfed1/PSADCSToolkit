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
            Name    = 'authorityRevocationList'
            Type    = [System.Byte[][]]
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
            Name    = 'cAConnect'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'cAUsages'
            Type    = [System.String[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'cAWEBURL'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'certificateRevocationList'
            Type    = [System.Byte[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'certificateTemplates'
            Type    = [System.String[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'cn'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'cRLObject'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'crossCertificatePair'
            Type    = [System.Security.Cryptography.X509Certificates.X509Certificate2[]] #[System.Byte[][]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'currentParentCA'
            Type    = [System.String[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'deltaRevocationList'
            Type    = [System.Byte[][]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'dNSHostName'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'domainID'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'domainPolicyObject'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'enrollmentProviders'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'parentCA'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'parentCACertificateChain'
            Type    = [System.Byte[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'pendingCACertificates'
            Type    = [System.Byte[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'pendingParentCA'
            Type    = [System.String[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'previousCACertificates'
            Type    = [System.Byte[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'previousParentCA'
            Type    = [System.String[]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'searchGuide'
            Type    = [System.Byte[][]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'signatureAlgorithms'
            Type    = [System.String]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'supportedApplicationContext'
            Type    = [System.Byte[][]]
            Mandatory = $false
        }
        [PSCustomObject]@{
            Name    = 'teletexTerminalIdentifier'
            Type    = [System.Byte[][]]
            Mandatory = $false
        }
    )
}