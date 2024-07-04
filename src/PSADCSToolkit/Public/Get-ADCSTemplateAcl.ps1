<#
.SYNOPSIS
Retrieves Access Control Lists (ACLs) for Active Directory Certificate Services (ADCS) certificate templates.

.DESCRIPTION
Retrieves ACLs for ADCS certificate templates based on name, display name, or input object.
Converts principal names and resolves schema rights for each ACL entry.

.PARAMETER Name
Specifies the name of the ADCS certificate template to retrieve ACLs for.

.PARAMETER DisplayName
Specifies the display name of the ADCS certificate template to retrieve ACLs for.

.PARAMETER InputObject
Specifies an ADCSTemplate object from which to retrieve ACLs.

.PARAMETER IncludePrincipalDomain
Switch parameter to include the domain part in principal names.

.PARAMETER ExcludeInheritedAce
Exclude inherited Dacl and Sacl aces in the output.

.PARAMETER Server
Specifies the server to connect to for retrieving ADCS information.

.OUTPUTS
PSCustomObject with type 'ADCSTemplateAcl'.

.EXAMPLE
PS C:\> Get-ADCSTemplateAcl -Name "WebServer"

Retrieves ACLs for the ADCS certificate template named "WebServer".

.EXAMPLE
PS C:\> Get-ADCSTemplateAcl -DisplayName "Web Server Authentication"

Retrieves ACLs for the ADCS certificate template with the display name "Web Server Authentication".

.EXAMPLE
PS C:\> Get-ADCSTemplate -Name "UserTemplate" | Get-ADCSTemplateAcl -IncludePrincipalDomain

Retrieves ACLs for the ADCS certificate template named "WebServer" and includes the domain part of the principal names in the output.
#>
function Get-ADCSTemplateAcl {
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    [OutputType('ADCSTemplateAcl')]
    param (
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
        [PSTypeName('ADCSTemplate')]$InputObject,

        [Parameter(Mandatory = $false)]
        [switch]$IncludePrincipalDomain = $false,

        [Parameter()]
        [switch]$ExcludeInheritedAce = $false,

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

        New-PSDrive @common -Name CUSTOMAD -PSProvider ActiveDirectory -Root "" -WhatIf:$false | Out-Null
    }

    process {
        if ($PSBoundParameters.ContainsKey('Name')) {
            $templates = Get-ADCSTemplate @common -Name $Name -Properties Name, DistinguishedName
        }
        elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
            $templates = Get-ADCSTemplate @common -DisplayName $DisplayName -Properties Name, DistinguishedName
        }
        elseif ($PSBoundParameters.ContainsKey('InputObject')) {
            $templates = $InputObject
        }

        foreach ($template in $templates) {
            $templatePath = "CUSTOMAD:\$($template.DistinguishedName)"
            $acl = Get-ACL -Path $templatePath -Audit

            if ($null -eq $acl) {
                # Get-ACL silently fails when retrieving audit sacls lowpriv user on DC's due to missing SeSecurityPrivilege
                Write-Warning -Message "Failed to retrieve audit sacls. Please elevate to administrator."

                $acl = Get-ACL -Path $templatePath
                $acl | Add-Member -Type NoteProperty -Name Audit -Value @()
            }

            # Function to convert (transform) a principal name
            function Convert-PrincipalName {
                param (
                    [System.String]$Principal,
                    [switch]$IncludePrincipalDomain = $false
                )
                if (-not $IncludePrincipalDomain) {
                    return ($Principal -replace '^[^\\]+\\', '')
                }
                else {
                    return $Principal
                }
            }

            # Convert (transform) principals based on the RemoveDomainPart switch
            $group = Convert-PrincipalName -Principal $acl.Group -IncludePrincipalDomain:$IncludePrincipalDomain
            $owner = Convert-PrincipalName -Principal $acl.Owner -IncludePrincipalDomain:$IncludePrincipalDomain

            $dacls = [System.Collections.ArrayList]@()
            foreach ($ace in $acl.Access) {
                if (($ExcludeInheritedAce -eq $true) -and ($ace.IsInherited -eq $true)) {
                    continue
                }

                $objectType = (Resolve-SchemaRightsName @common -ObjectGuid $ace.ObjectType) | Select-Object -ExpandProperty Name
                if (-not $objectType) {
                    # default to guid
                    $objectType = $ace.ObjectType
                }

                $inheritedObjectType = (Resolve-SchemaRightsName @common -ObjectGuid $ace.InheritedObjectType) | Select-Object -ExpandProperty Name
                if (-not $inheritedObjectType) {
                    $inheritedObjectType = $ace.InheritedObjectType
                }

                $aceObject = [PSCustomObject]@{
                    PSTypeName            = "ADCSTemplateDacl"
                    IdentityReference     = Convert-PrincipalName -Principal $ace.IdentityReference.ToString() -IncludePrincipalDomain:$IncludePrincipalDomain
                    ActiveDirectoryRights = $ace.ActiveDirectoryRights.ToString()
                    AccessControlType     = $ace.AccessControlType.ToString()
                    ObjectType            = $objectType
                    InheritanceType       = $ace.InheritanceType.ToString()
                    InheritedObjectType   = $inheritedObjectType
                    IsInherited           = $ace.IsInherited
                }

                $dacls.Add($aceObject) | Out-Null
            }

            $sacls = [System.Collections.ArrayList]@()
            foreach ($ace in $acl.Audit) {
                if (($ExcludeInheritedAce -eq $true) -and ($ace.IsInherited -eq $true)) {
                    continue
                }

                $objectType = (Resolve-SchemaRightsName @common -ObjectGuid $ace.ObjectType) | Select-Object -ExpandProperty Name
                if (-not $objectType) {
                    # default to guid
                    $objectType = $ace.ObjectType
                }

                $inheritedObjectType = (Resolve-SchemaRightsName @common -ObjectGuid $ace.InheritedObjectType) | Select-Object -ExpandProperty Name
                if (-not $inheritedObjectType) {
                    $inheritedObjectType = $ace.InheritedObjectType
                }

                $aceObject = [PSCustomObject]@{
                    PSTypeName            = "ADCSTemplateSacl"
                    IdentityReference     = Convert-PrincipalName -Principal $ace.IdentityReference.ToString() -IncludePrincipalDomain:$IncludePrincipalDomain
                    ActiveDirectoryRights = $ace.ActiveDirectoryRights.ToString()
                    AuditFlags            = $ace.AuditFlags.ToString()
                    ObjectType            = $objectType
                    InheritanceType       = $ace.InheritanceType.ToString()
                    InheritedObjectType   = $inheritedObjectType
                    IsInherited           = $ace.IsInherited
                }

                $sacls.Add($aceObject) | Out-Null
            }

            # Create a custom object to hold the information
            $templateAcl = [PSCustomObject]@{
                PSTypeName              = "ADCSTemplateAcl"
                TemplateName            = $template.Name
                Group                   = $group
                Owner                   = $owner
                DACLs                   = $dacls
                SACLs                   = $sacls
                AreAccessRulesProtected = $acl.AreAccessRulesProtected
                AreAuditRulesProtected  = $acl.AreAuditRulesProtected
            }

            Write-Output -InputObject $templateAcl
        }
    }
    end {
        Remove-PSDrive -Name CUSTOMAD -WhatIf:$false
    }
}