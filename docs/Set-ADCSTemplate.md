---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Set-ADCSTemplate

## SYNOPSIS
Updates the properties of an ADCS (Active Directory Certificate Services) certificate template.

## SYNTAX

### JsonInput
```
Set-ADCSTemplate [-Name] <String> -Json <String> [-PassThru] [-Server <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ObjectInput
```
Set-ADCSTemplate [-Name] <String> -InputObject <Object> [-PassThru] [-Server <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function updates the properties of an ADCS certificate template based on the specified name and provided input (JSON or object).
It supports updating issuance policies, and other properties as defined in the ADCSTemplatePropertyMap.
The function supports ShouldProcess for confirmation prompts and can output the updated template if requested.

## EXAMPLES

### EXAMPLE 1
```
Set-ADCSTemplate -Name "UserTemplate" -Json '{"displayName":"Updated User Template"}'
```

This example updates the display name of the certificate template named "UserTemplate" to "Updated User Template" using a JSON input.

## PARAMETERS

### -InputObject
Specifies the object representing the properties to update.

```yaml
Type: System.Object
Parameter Sets: ObjectInput
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Json
Specifies the JSON string representing the properties to update.

```yaml
Type: System.String
Parameter Sets: JsonInput
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
If specified, the function returns the updated template object.

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

### PSCustomObject with type 'ADCSTemplate' - if the passthru parameter is set.
## NOTES

## RELATED LINKS
