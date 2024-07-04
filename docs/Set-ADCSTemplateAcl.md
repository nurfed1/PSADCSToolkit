---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Set-ADCSTemplateAcl

## SYNOPSIS
Sets the ACL (Access Control List) of an ADCS (Active Directory Certificate Services) certificate template.

## SYNTAX

### Json
```
Set-ADCSTemplateAcl [-Name] <String> -Json <String> [-ImportInheritedAce] [-PassThru] [-Server <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### InputObject
```
Set-ADCSTemplateAcl [-Name] <String> -InputObject <Object> [-ImportInheritedAce] [-PassThru] [-Server <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function sets the ACL of an ADCS certificate template based on the specified name and provided input (JSON or object).
It supports updating owner, group, DACLs (Discretionary Access Control Lists), and SACLs (System Access Control Lists).

## EXAMPLES

### EXAMPLE 1
```
$aclJson = @"
```

{
    "Owner": "domain\User1",
    "Group": "domain\Group1",
    "DACLs": \[
        {
            "IdentityReference": "domain\User2",
            "ActiveDirectoryRights": "GenericRead",
            "AccessControlType": "Allow",
            "ObjectType": "00000000-0000-0000-0000-000000000000",
            "InheritanceType": "None",
            "InheritedObjectType": "00000000-0000-0000-0000-000000000000"
        }
    \],
    "SACLs": \[\],
    "AreAccessRulesProtected": $true,
    "AreAuditRulesProtected": $true
}
"@
PS C:\\\> Set-ADCSTemplateAcl -Name "UserTemplate" -Json $aclJson

This example sets the ACL of the certificate template named "UserTemplate" using a JSON input.

## PARAMETERS

### -ImportInheritedAce
Specifies if inherited aces should be imported.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Specifies the object representing the ACL properties to update.

```yaml
Type: System.Object
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Json
Specifies the JSON string representing the ACL properties to update.

```yaml
Type: System.String
Parameter Sets: Json
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the ADCS certificate template to update.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
```

### -PassThru
If specified, the function returns the updated ACL object.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Specifies the Active Directory server to connect to.
If not specified, the default server is used.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### ADCSTemplateAcl
## NOTES

## RELATED LINKS
