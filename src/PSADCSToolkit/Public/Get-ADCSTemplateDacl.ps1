<#
.SYNOPSIS
Retrieves the discretionary access control list (DACL) for an ADCS certificate template.

.DESCRIPTION
This function retrieves the DACL for a specified Active Directory Certificate Services (ADCS) certificate template.
Depending on the `-Detailed` switch parameter, it either summarizes the permissions per principal or provides detailed
information about each access control entry (ACE) in the DACL.

.PARAMETER Name
Specifies the name of the ADCS certificate template.

.PARAMETER Server
Specifies the Active Directory server to connect to.

.PARAMETER Detailed
Switch parameter. If specified, provides detailed information about each ACE in the DACL.

.OUTPUTS
System.Object
Returns custom objects representing DACL information. For `-Detailed` mode, includes Type, Principal, Rights, and Property.
For standard mode, includes Principal, AllowPermissions, and DenyPermissions.

.EXAMPLE
PS C:\> Get-ADCSTemplateDacl -Name "User" -Detailed

Retrieves detailed DACL information for the ADCS certificate template with the name "User".

.EXAMPLE
Get-ADCSTemplateDacl -Name "User"

Retrieves DACL information for the ADCS certificate template with the name "User".
#>
Function Get-ADCSTemplateDacl {
    [CmdletBinding()]
    [OutputType([System.Object])]
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

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Server,

        [Parameter(Mandatory = $false)]
        [switch]$Detailed
    )

    begin {
        $ErrorActionPreference = 'Stop'

        $common = @{}
        if ($PSBoundParameters.ContainsKey('Server')) {
            $common.Server = $server
        }

        New-PSDrive @common -Name CUSTOMAD -PSProvider ActiveDirectory -Root "" -WhatIf:$false | Out-Null
    }
    process {
        $template = Get-ADCSTemplate @common -Name $Name -Properties Name, DistinguishedName

        $templatePath = "CUSTOMAD:\$($template.DistinguishedName)"
        $acl = Get-ACL -Path $templatePath

        if (-not $Detailed) {
            $identityGroups = $acl.Access | Group-Object -Property IdentityReference
            foreach ($group in $identityGroups) {

                $allowPermissions = [System.Collections.ArrayList]@()
                $denyPermissions = [System.Collections.ArrayList]@()
                foreach ($ace in $group.Group) {
                    $rights = $ace.ActiveDirectoryRights
                    $objectType = $ace.ObjectType
                    $permissions = [System.Collections.ArrayList]@()

                    # Enroll rights
                    if ($rights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight)) {
                        switch ($objectType) {
                            'a05b8cc2-17bc-4802-a710-e7c15ab866a2' {
                                $permissions.Add('AutoEnroll') | Out-Null
                            }
                            '0e10c968-78fb-11d2-90d4-00c04f79dc55' {
                                $permissions.Add('Enroll') | Out-Null
                            }
                            "00000000-0000-0000-0000-000000000000" {
                                $permissions.Add('AutoEnroll') | Out-Null
                                $permissions.Add('Enroll') | Out-Null
                            }
                        }
                    }

                    # Full Control rights
                    if ($objectType -eq "00000000-0000-0000-0000-000000000000" -and
                        $rights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::GenericAll)) {
                        $permissions.Add('FullControl') | Out-Null
                    }

                    # Read rights
                    if ($objectType -eq "00000000-0000-0000-0000-000000000000" -and
                        $rights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::GenericRead)) {
                        $permissions.Add('Read') | Out-Null
                    }

                    # Write rights
                    if ($objectType -eq "00000000-0000-0000-0000-000000000000" -and
                        (
                            $rights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::WriteDacl) -or
                            $rights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::WriteProperty) -or
                            $rights.HasFlag([System.DirectoryServices.ActiveDirectoryRights]::WriteOwner)
                        )
                    ) {
                        $permissions.Add('Write') | Out-Null
                    }

                    if ($ace.AccessControlType.HasFlag([System.Security.AccessControl.AccessControlType]::Allow)) {
                        $allowPermissions.AddRange($permissions)
                    }
                    else {
                        $denyPermissions.AddRange($permissions)
                    }
                }

                $templateDacl = [PSCustomObject]@{
                    Principal        = $group.Name
                    AllowPermissions = ($allowPermissions | Select-Object -Unique)
                    DenyPermissions  = ($denyPermissions | Select-Object -Unique)
                }

                Write-Output -InputObject $templateDacl
            }
        }
        else {
            # Detailed
            $acl.Access | ForEach-Object {
                $ace = $_
                $objectType = $ace.ObjectType

                # Default value
                $property = "Unknown ($objectType)"
                # "00000000-0000-0000-0000-000000000000" is a special guid
                if ($objectType -eq "00000000-0000-0000-0000-000000000000") {
                    $property = "All Properties"
                }
                else {
                    $rightsObj = Resolve-SchemaRightsName @common -ObjectGuid $objectType

                    if($rightsObj) {
                        $property = "$($rightsObj.Name) ($($rightsObj.DisplayName))"
                    }
                }

                $templateDacl = [PSCustomObject]@{
                    Type      = $ace.AccessControlType
                    Principal = $ace.IdentityReference
                    Rights    = $ace.ActiveDirectoryRights
                    Property  = $property
                }

                Write-Output -InputObject $templateDacl
            }
        }
    }
    end {
        Remove-PSDrive -Name CUSTOMAD -WhatIf:$false
    }
}
