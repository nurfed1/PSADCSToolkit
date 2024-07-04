<#
.SYNOPSIS
Adds a DACL (Discretionary Access Control List) ACE (Access Control Entry) to an ADCS (Active Directory Certificate Services) certificate template.

.DESCRIPTION
This function adds a DACL ACE to an ADCS certificate template based on the specified name and provided input (basic or advanced rights).
It supports setting specific rights such as 'AutoEnroll', 'Enroll', 'Read', and 'Write', or advanced rights through the ActiveDirectoryRights parameter.

.PARAMETER Name
Specifies the name of the ADCS certificate template to update.

.PARAMETER Identity
Specifies the identity (user or group) to which the ACE will be applied.

.PARAMETER AccessControlType
Specifies the access control type (Allow or Deny). Defaults to 'Allow'.

.PARAMETER Rights
Specifies the basic rights to assign. This parameter can be 'AutoEnroll', 'Enroll', 'Read', or 'Write'.

.PARAMETER ActiveDirectoryRights
Specifies the advanced rights to assign.

.PARAMETER ObjectType
Specifies the object type for the ACE. Defaults to '00000000-0000-0000-0000-000000000000'.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, the default server is used.

.OUTPUTS
System.Void

.EXAMPLE
PS C:\> Add-ADCSTemplateDaclAce -Name "UserTemplate" -Identity "Domain\User" -Rights "Enroll"

This example adds an Enroll ACE for "Domain\User" to the "UserTemplate" certificate template.

.EXAMPLE
PS C:\> Add-ADCSTemplateDaclAce -Name "UserTemplate" -Identity "Domain\User" -ActiveDirectoryRights "GenericRead" -AccessControlType "Allow"

This example adds a GenericRead ACE for "Domain\User" to the "UserTemplate" certificate template using advanced rights.
#>
Function Add-ADCSTemplateDaclAce {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Basic')]
    [OutputType([System.Void])]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [System.String]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Identity,

        [Parameter(Mandatory = $false)]
        [System.Security.AccessControl.AccessControlType]$AccessControlType = 'Allow',

        [Parameter(Mandatory = $true, ParameterSetName = 'Basic')]
        [ValidateSet('AutoEnroll', 'Enroll', 'Read', 'Write')]
        [System.String[]]$Rights,

        [Parameter(Mandatory = $true, ParameterSetName = 'Advanced')]
        [System.DirectoryServices.ActiveDirectoryRights]$ActiveDirectoryRights,

        [Parameter(Mandatory = $false, ParameterSetName = 'Advanced')]
        [System.Guid]$ObjectType = "00000000-0000-0000-0000-000000000000",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )
    Begin {
        $ErrorActionPreference = 'Stop'

        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $Server
        }

        New-PSDrive @common -Name CUSTOMAD -PSProvider ActiveDirectory -Root "" -WhatIf:$false | Out-Null
    }

    process {
        $templates = Get-ADCSTemplate @common -Name $Name -Properties Name, DistinguishedName

        foreach ($template in $templates) {

            $templatePath = "CUSTOMAD:\$($template.DistinguishedName)"
            $acl = Get-ACL -Path $templatePath

            $inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
            $inheritedObjectType = [GUID]'00000000-0000-0000-0000-000000000000'

            $principal = New-Object System.Security.Principal.NTAccount($Identity)
            $identityReference = $principal.Translate([System.Security.Principal.SecurityIdentifier])

            if ($PSCmdlet.ParameterSetName -eq "Basic") {
                foreach ($right in $Rights) {
                    switch ($right) {
                        'AutoEnroll' {
                            $ObjectType = [GUID]'a05b8cc2-17bc-4802-a710-e7c15ab866a2'
                            $ActiveDirectoryRights = [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight
                        }
                        'Enroll' {
                            $ObjectType = [GUID]'0e10c968-78fb-11d2-90d4-00c04f79dc55'
                            $ActiveDirectoryRights = [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight
                        }
                        'Read' {
                            $ObjectType = [System.Guid]'00000000-0000-0000-0000-000000000000'
                            $ActiveDirectoryRights = [System.DirectoryServices.ActiveDirectoryRights]::GenericRead
                        }
                        'Write' {
                            $ObjectType = [System.Guid]'00000000-0000-0000-0000-000000000000'
                            $ActiveDirectoryRights = [System.DirectoryServices.ActiveDirectoryRights]"WriteDacl,WriteProperty,WriteOwner"
                        }

                        default {
                            Write-Error "Unknown Right '$_'."
                        }
                    }

                    if ($PSCmdlet.ShouldProcess($template.DistinguishedName, "Adding $AccessControlType DACL with $right rights for $Identity")) {
                        $rule = [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
                            $identityReference,
                            $ActiveDirectoryRights,
                            $AccessControlType,
                            $ObjectType,
                            $inheritanceType,
                            $inheritedObjectType
                        );

                        $acl.AddAccessRule($rule)
                    }
                }
            }
            else {
                if ($PSCmdlet.ShouldProcess($template.DistinguishedName, "Adding $AccessControlType DACL with $ActiveDirectoryRights rights for $Identity")) {
                    $rule = [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
                        $identityReference,
                        $ActiveDirectoryRights,
                        $AccessControlType,
                        $ObjectType,
                        $inheritanceType,
                        $inheritedObjectType
                    );

                    $acl.AddAccessRule($rule)
                }
            }

            if ($PSCmdlet.ShouldProcess($template.DistinguishedName, "Applying DACL to certificate template")) {
                Set-ACL -Path $templatePath -AclObject $acl
            }
        }
    }

    end {
        Remove-PSDrive -Name CUSTOMAD -WhatIf:$false
    }
}
