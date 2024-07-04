---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Add-ADCSTemplateDaclAce

## SYNOPSIS
Adds a DACL (Discretionary Access Control List) ACE (Access Control Entry) to an ADCS (Active Directory Certificate Services) certificate template.

## SYNTAX

### Basic (Default)
```
Add-ADCSTemplateDaclAce [-Name] <String> -Identity <String> [-AccessControlType <AccessControlType>]
 -Rights <String[]> [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Advanced
```
Add-ADCSTemplateDaclAce [-Name] <String> -Identity <String> [-AccessControlType <AccessControlType>]
 -ActiveDirectoryRights <ActiveDirectoryRights> [-ObjectType <Guid>] [-Server <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function adds a DACL ACE to an ADCS certificate template based on the specified name and provided input (basic or advanced rights).
It supports setting specific rights such as 'AutoEnroll', 'Enroll', 'Read', and 'Write', or advanced rights through the ActiveDirectoryRights parameter.

## EXAMPLES

### EXAMPLE 1
```
Add-ADCSTemplateDaclAce -Name "UserTemplate" -Identity "Domain\User" -Rights "Enroll"
```

This example adds an Enroll ACE for "Domain\User" to the "UserTemplate" certificate template.

### EXAMPLE 2
```
Add-ADCSTemplateDaclAce -Name "UserTemplate" -Identity "Domain\User" -ActiveDirectoryRights "GenericRead" -AccessControlType "Allow"
```

This example adds a GenericRead ACE for "Domain\User" to the "UserTemplate" certificate template using advanced rights.

## PARAMETERS

### -AccessControlType
Specifies the access control type (Allow or Deny).
Defaults to 'Allow'.

```yaml
Type: System.Security.AccessControl.AccessControlType
Parameter Sets: (All)
Aliases:
Accepted values: Allow, Deny

Required: False
Position: Named
Default value: Allow
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActiveDirectoryRights
Specifies the advanced rights to assign.

```yaml
Type: System.DirectoryServices.ActiveDirectoryRights
Parameter Sets: Advanced
Aliases:
Accepted values: CreateChild, DeleteChild, ListChildren, Self, ReadProperty, WriteProperty, DeleteTree, ListObject, ExtendedRight, Delete, ReadControl, GenericExecute, GenericWrite, GenericRead, WriteDacl, WriteOwner, GenericAll, Synchronize, AccessSystemSecurity

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
Specifies the identity (user or group) to which the ACE will be applied.

```yaml
Type: System.String
Parameter Sets: (All)
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

### -ObjectType
Specifies the object type for the ACE.
Defaults to '00000000-0000-0000-0000-000000000000'.

```yaml
Type: System.Guid
Parameter Sets: Advanced
Aliases:

Required: False
Position: Named
Default value: 00000000-0000-0000-0000-000000000000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rights
Specifies the basic rights to assign.
This parameter can be 'AutoEnroll', 'Enroll', 'Read', or 'Write'.

```yaml
Type: System.String[]
Parameter Sets: Basic
Aliases:

Required: True
Position: Named
Default value: None
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

### System.Void
## NOTES

## RELATED LINKS
