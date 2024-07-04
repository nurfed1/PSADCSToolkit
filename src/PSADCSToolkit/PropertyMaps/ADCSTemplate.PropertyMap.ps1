@{
    Properties = @(
        <#
        Export: Properties that should not be exported.
        Import: Properties that should be imported.
        Mandatory: Properties that should be always returned in an object
        #>
        [PSCustomObject]@{
            ADProperty   = 'Name'
            ADType       = [System.String]
            PropertyName = 'Name'
            PropertyType = [System.String]
            Export       = $true
            Import       = $false
            Mandatory    = $true
        }
        [PSCustomObject]@{
            ADProperty   = 'DistinguishedName'
            ADType       = [System.String]
            PropertyName = 'DistinguishedName'
            PropertyType = [System.String]
            Export       = $false
            Import       = $false
            Mandatory    = $true
        }
        [PSCustomObject]@{
            ADProperty   = 'DisplayName'
            ADType       = [System.String]
            PropertyName = 'DisplayName'
            PropertyType = [System.String]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'flags'
            ADType       = [System.Int32]
            PropertyName = 'TemplateFlags'
            PropertyType = [ADCSTemplateFlags]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Certificate-Application-Policy'
            ADType       = [System.String[]]
            PropertyName = 'CertificateApplicationPolicy'
            PropertyType = [Security.Cryptography.Oid[]]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Certificate-Name-Flag'
            ADType       = [System.Int32]
            PropertyName = 'CertificateNameFlag'
            PropertyType = [ADCSTemplateCertificateNameFlags]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Certificate-Policy'
            ADType       = [System.String[]]
            PropertyName = 'CertificatePolicy'
            PropertyType = [Security.Cryptography.Oid[]]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Cert-Template-OID'
            ADType       = [System.String]
            PropertyName = 'TemplateOID'
            PropertyType =  [Security.Cryptography.Oid]
            Export       = $true
            Import       = $false
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Enrollment-Flag'
            ADType       = [System.Int32]
            PropertyName = 'EnrollmentFlag'
            PropertyType = [ADCSTemplateEnrollmentFlags]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Minimal-Key-Size'
            ADType       = [System.Int32]
            PropertyName = 'MinimalKeySize'
            PropertyType = [System.Int32]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Private-Key-Flag'
            ADType       = [System.Int32]
            PropertyName = 'PrivateKeyFlag'
            PropertyType = [ADCSTemplatePrivateKeyFlags]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-RA-Application-Policies'
            ADType       = [System.String[]]
            PropertyName = 'RegistrationAuthorityApplicationPolicies'
            PropertyType = [System.String[]]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-RA-Policies'
            ADType       = [System.String[]]
            PropertyName = 'RegistrationAuthorityPolicies'
            PropertyType = [Security.Cryptography.Oid[]]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-RA-Signature'
            ADType       = [System.Int32]
            PropertyName = 'RegistrationAuthoritySignatureCount'
            PropertyType = [System.Int32]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Supersede-Templates'
            ADType       = [System.String[]]
            PropertyName = 'SupersedeTemplates'
            PropertyType = [System.String[]]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Template-Minor-Revision'
            ADType       = [System.Int32]
            PropertyName = 'MinorRevision'
            PropertyType = [System.Int32]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'msPKI-Template-Schema-Version'
            ADType       = [System.Int32]
            PropertyName = 'SchemaVersion'
            PropertyType = [System.Int32]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'pKICriticalExtensions'
            ADType       = [System.String[]]
            PropertyName = 'CriticalExtensions'
            PropertyType = [Security.Cryptography.Oid[]]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'pKIDefaultCSPs'
            ADType       = [System.String[]]
            PropertyName = 'DefaultCSPs'
            PropertyType = [System.String[]]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'pKIDefaultKeySpec'
            ADType       = [System.Int32]
            PropertyName = 'DefaultKeySpec'
            PropertyType = [ADCSTemplateKeySpecFlags]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        #TODO: pKIEnrollmentAccess ?
        [PSCustomObject]@{
            ADProperty   = 'pKIExpirationPeriod'
            ADType       = [System.Byte[]]
            PropertyName = 'ExpirationPeriod'
            PropertyType = [TimeSpan]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'pKIExtendedKeyUsage'
            ADType       = [System.String[]]
            PropertyName = 'ExtendedKeyUsage'
            PropertyType = [Security.Cryptography.Oid[]]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'pKIKeyUsage'
            ADType       = [System.Byte[]]
            PropertyName = 'KeyUsage'
            PropertyType = [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'pKIMaxIssuingDepth'
            ADType       = [System.Int32]
            PropertyName = 'MaxIssuingDepth'
            PropertyType = [System.Int32]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'pKIOverlapPeriod'
            ADType       = [System.Byte[]]
            PropertyName = 'OverlapPeriod'
            PropertyType = [TimeSpan]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
        [PSCustomObject]@{
            ADProperty   = 'revision'
            ADType       = [System.Int32]
            PropertyName = 'revision'
            PropertyType = [System.Int32]
            Export       = $true
            Import       = $true
            Mandatory    = $false
        }
    )
}
