<#
.SYNOPSIS
Sets the ACL (Access Control List) of an ADCS (Active Directory Certificate Services) certificate template.

.DESCRIPTION
This function sets the ACL of an ADCS certificate template based on the specified name and provided input (JSON or object).
It supports updating owner, group, DACLs (Discretionary Access Control Lists), and SACLs (System Access Control Lists).

.PARAMETER Name
Specifies the name of the ADCS certificate template to update.

.PARAMETER Json
Specifies the JSON string representing the ACL properties to update.

.PARAMETER InputObject
Specifies the object representing the ACL properties to update.

.PARAMETER ImportInheritedAce
Specifies if inherited aces should be imported.

.PARAMETER PassThru
If specified, the function returns the updated ACL object.

.PARAMETER Server
Specifies the Active Directory server to connect to. If not specified, the default server is used.

.EXAMPLE
PS C:\> $aclJson = @"
{
    "Owner": "domain\User1",
    "Group": "domain\Group1",
    "DACLs": [
        {
            "IdentityReference": "domain\User2",
            "ActiveDirectoryRights": "GenericRead",
            "AccessControlType": "Allow",
            "ObjectType": "00000000-0000-0000-0000-000000000000",
            "InheritanceType": "None",
            "InheritedObjectType": "00000000-0000-0000-0000-000000000000"
        }
    ],
    "SACLs": [],
    "AreAccessRulesProtected": $true,
    "AreAuditRulesProtected": $true
}
"@
PS C:\> Set-ADCSTemplateAcl -Name "UserTemplate" -Json $aclJson

This example sets the ACL of the certificate template named "UserTemplate" using a JSON input.
#>
Function Set-ADCSTemplateAcl {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType('ADCSTemplateAcl')]
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

        [Parameter(Mandatory = $true, ParameterSetName = 'Json')]
        [ValidateNotNullOrEmpty()]
        [System.String]$Json,

        [Parameter(Mandatory = $true, ParameterSetName = 'InputObject')]
        [ValidateNotNullOrEmpty()]
        [System.Object]$InputObject,

        [Parameter()]
        [switch]$ImportInheritedAce = $false,

        [Parameter(Mandatory = $false)]
        [switch]$PassThru = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server
    )

    Begin {
        $ErrorActionPreference = 'Stop'

        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $server
        }

        if ($PSBoundParameters.ContainsKey('Json')) {
            $InputObject = $Json | ConvertFrom-Json
        }

        New-PSDrive @common -Name CUSTOMAD -PSProvider ActiveDirectory -Root "" -WhatIf:$false | Out-Null
    }

    process {
        $templates = Get-ADCSTemplate @common -Name $Name

        foreach ($template in $templates) {
            $newAcl = New-Object System.DirectoryServices.ActiveDirectorySecurity

            if (-not [string]::IsNullOrEmpty($InputObject.Owner)) {
                $principal = New-Object System.Security.Principal.NTAccount($InputObject.Owner)
                $owner = $principal.Translate([System.Security.Principal.SecurityIdentifier])
                $newAcl.SetOwner($owner)
            }

            if (-not [string]::IsNullOrEmpty($InputObject.Group)) {
                $principal = New-Object System.Security.Principal.NTAccount($InputObject.Group)
                $group = $principal.Translate([System.Security.Principal.SecurityIdentifier])
                $newAcl.SetGroup($group)
            }

            foreach ($ace in $InputObject.DACLs) {
                if (($ImportInheritedAce -eq $false) -and ($ace.IsInherited -eq $true)) {
                    continue
                }

                $principal = New-Object System.Security.Principal.NTAccount($ace.IdentityReference)
                $identityReference = $principal.Translate([System.Security.Principal.SecurityIdentifier])

                $activeDirectoryRights = [System.DirectoryServices.ActiveDirectoryRights]$ace.ActiveDirectoryRights
                $accessControlType = [System.Security.AccessControl.AccessControlType]$ace.AccessControlType
                $inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]$ace.InheritanceType

                if (Test-IsGuid -guidString $ace.ObjectType) {
                    $objectType = [System.Guid]$ace.ObjectType
                }
                else {
                    $objectType = Resolve-SchemaRightsGuid @common -ObjectName $ace.ObjectType
                }

                if (Test-IsGuid -guidString $ace.InheritedObjectType) {
                    $inheritedObjectType = [System.Guid]$ace.InheritedObjectType
                }
                else {
                    $inheritedObjectType = Resolve-SchemaRightsGuid @common -ObjectName $ace.ObjectType
                }

                $Rule = [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
                    $identityReference,
                    $activeDirectoryRights,
                    $accessControlType,
                    $objectType,
                    $inheritanceType,
                    $inheritedObjectType
                );

                $newAcl.AddAccessRule($Rule)
            }

            foreach ($ace in $InputObject.SACLs) {
                if (($ImportInheritedAce -eq $false) -and ($ace.IsInherited -eq $true)) {
                    continue
                }

                $principal = New-Object System.Security.Principal.NTAccount($ace.IdentityReference)
                $identityReference = $principal.Translate([System.Security.Principal.SecurityIdentifier])

                $activeDirectoryRights = [System.DirectoryServices.ActiveDirectoryRights]$ace.ActiveDirectoryRights
                $auditFlags = [System.Security.AccessControl.AuditFlags]$ace.AuditFlags
                $inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]$ace.InheritanceType

                if (Test-IsGuid -guidString $ace.ObjectType) {
                    $objectType = [System.Guid]$ace.ObjectType
                }
                else {
                    $objectType = Resolve-SchemaRightsGuid @common -ObjectName $ace.ObjectType
                }

                if (Test-IsGuid -guidString $ace.InheritedObjectType) {
                    $inheritedObjectType = [System.Guid]$ace.InheritedObjectType
                }
                else {
                    $inheritedObjectType = Resolve-SchemaRightsGuid @common -ObjectName $ace.ObjectType
                }

                $Rule = [System.DirectoryServices.ActiveDirectoryAuditRule]::new(
                    $identityReference,
                    $activeDirectoryRights,
                    $auditFlags,
                    $objectType,
                    $inheritanceType,
                    $inheritedObjectType
                );

                $newAcl.AddAuditRule($Rule)
            }

            $newAcl.SetAccessRuleProtection($InputObject.AreAccessRulesProtected, $false)
            $newAcl.SetAuditRuleProtection($InputObject.AreAuditRulesProtected, $false)

            $templatePath = "CUSTOMAD:\$($template.DistinguishedName)"
            if ($PSCmdlet.ShouldProcess($template.DistinguishedName, "Set certificate template ACL")) {
                Set-ACL -Path $templatePath -AclObject $newAcl
            }

            if ($PassThru) {
                if ($PSCmdlet.ShouldProcess($template.DistinguishedName, "Retrieving certificate template ACL")) {
                    Write-Output -InputObject (Get-ADCSTemplateAcl @common -Name $template.Name)
                }
            }
        }
    }

    end {
        Remove-PSDrive -Name CUSTOMAD -WhatIf:$false
    }
}
