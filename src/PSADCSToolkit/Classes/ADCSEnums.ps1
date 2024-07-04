# [Flags()]
# enum ADCSTemplateKeyUsageFlags {
#     DigitalSignature    = 0x80
#     NonRepudiation      = 0x40
#     KeyEncipherment     = 0x20
#     DataEncipherment    = 0x10
#     KeyAgreement        = 0x08
#     KeyCertSign         = 0x04
#     CRLSign             = 0x02
#     EncipherOnly        = 0x01
#     DecipherOnly        = 0x8000
#     None                = 0x0
# }

# https://github.com/PKISolutions/pkix.net/blob/master/src/SysadminsLV.PKI.Win/CertificateTemplates/PrivateKeyFlags.cs
[Flags()]
enum ADCSTemplatePrivateKeyFlags {
    None                               = 0
    RequireKeyArchival                 = 0x00000001
    AllowKeyExport                     = 0x00000010
    RequireStrongProtection            = 0x00000020
    RequireAlternateSignatureAlgorithm = 0x00000040
    ReuseKeysRenewal                   = 0x00000080
    UseLegacyProvider                  = 0x00000100
    TrustOnUse                         = 0x00000200
    ValidateCert                       = 0x00000400
    ValidateKey                        = 0x00000800
    AttestationPreferred               = 0x00001000
    AttestationRequired                = 0x00002000
    AttestationWithoutPolicy           = 0x00004000
    Server2003                         = 0x00010000
    Server2008                         = 0x00020000
    Server2008R2                       = 0x00030000
    Server2012                         = 0x00040000
    Server2012R2                       = 0x00050000
    Server2016                         = 0x00060000
    HelloLogonKey                      = 0x00200000
    Client2003                         = 0x01000000
    Client2008                         = 0x02000000
    Client2008R2                       = 0x03000000
    Client2012                         = 0x04000000
    Client2012R2                       = 0x05000000
    Client2016                         = 0x06000000
}

# https://github.com/PKISolutions/pkix.net/blob/master/src/SysadminsLV.PKI.Win/CertificateTemplates/CertificateTemplateNameFlags.cs
[Flags()]
enum ADCSTemplateCertificateNameFlags {
    None                             = 0
    EnrolleeSuppliesSubject          = 0x00000001
    OldCertSuppliesSubjectAndAltName = 0x00000008
    EnrolleeSuppluiesAltSubject      = 0x00010000
    AltSubjectRequireDomainDNS       = 0x00400000
    AltSubjectRequireSPN             = 0x00800000
    AltSubjectRequireDirectoryGUID   = 0x01000000
    AltSubjectRequireUPN             = 0x02000000
    AltSubjectRequireEmail           = 0x04000000
    AltSubjectRequireDNS             = 0x08000000
    SubjectRequireDNSasCN            = 0x10000000
    SubjectRequireEmail              = 0x20000000
    SubjectRequireCommonName         = 0x40000000
    SubjectRequireDirectoryPath      = 0x80000000
}

# https://github.com/PKISolutions/pkix.net/blob/master/src/SysadminsLV.PKI.Win/CertificateTemplates/CertificateTemplateEnrollmentFlags.cs
[Flags()]
enum ADCSTemplateEnrollmentFlags {
    None                             = 0
    IncludeSymmetricAlgorithms       = 0x00000001
    CAManagerApproval                = 0x00000002
    KraPublish                       = 0x00000004
    DsPublish                        = 0x00000008
    AutoenrollmentCheckDsCert        = 0x00000010
    Autoenrollment                   = 0x00000020
    ReenrollExistingCert             = 0x00000040
    RequireUserInteraction           = 0x00000100
    RemoveInvalidFromStore           = 0x00000400
    AllowEnrollOnBehalfOf            = 0x00000800
    IncludeOcspRevNoCheck            = 0x00001000
    ReuseKeyTokenFull                = 0x00002000
    NoRevocationInformation          = 0x00004000
    BasicConstraintsInEndEntityCerts = 0x00008000
    IgnoreEnrollOnReenrollment       = 0x00010000
    IssuancePoliciesFromRequest      = 0x00020000
    SkipAutoRenewal                  = 0x00040000
    DoNotIncludeSidExtension         = 0x0008000
}

# https://github.com/PKISolutions/pkix.net/blob/master/src/SysadminsLV.PKI/ADCS/CertificateTemplates/CertificateTemplateFlags.cs
[Flags()]
enum ADCSTemplateFlags {
    None                    = 0
    EnrolleeSuppliesSubject = 0x1
    AddEmail                = 0x2
    AddObjectIdentifier     = 0x4
    DsPublish               = 0x8
    AllowKeyExport          = 0x10
    Autoenrollment          = 0x20
    MachineType             = 0x40
    IsCA                    = 0x80
    AddDirectoryPath        = 0x100
    AddTemplateName         = 0x200
    AddSubjectDirectoryPath = 0x400
    IsCrossCA               = 0x800
    DoNotPersistInDB        = 0x1000
    IsDefault               = 0x10000
    IsModified              = 0x20000
    IsDeleted               = 0x40000
    PolicyMismatch          = 0x80000
}


[Flags()]
enum ADCSTemplateKeySpecFlags {
    None             = 0
    KeyExchange      = 1
    DigitalSignature = 2
}
