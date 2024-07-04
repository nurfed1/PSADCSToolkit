---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Remove-ADCSTemplate

## SYNOPSIS
Removes certificate templates from Active Directory Certificate Services (ADCS).

## SYNTAX

### Name (Default)
```
Remove-ADCSTemplate [-Name] <String> [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### InputObject
```
Remove-ADCSTemplate [-InputObject] <Object> [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function removes the specified certificate templates from Active Directory, including unpublishing them from all
certificate authorities (CAs) and deleting the associated OID.

## EXAMPLES

### EXAMPLE 1
```
Remove-ADCSTemplate -DisplayName User
```

Removes the certificate template named "User" from Active Directory.

## PARAMETERS

### -InputObject
Specifies the certificate template object(s) to be removed.

```yaml
Type: System.Object
Parameter Sets: InputObject
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
Specifies the name of the certificate template(s) to be removed.

```yaml
Type: System.String
Parameter Sets: Name
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
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
