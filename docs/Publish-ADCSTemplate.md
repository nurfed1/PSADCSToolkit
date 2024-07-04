---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Publish-ADCSTemplate

## SYNOPSIS
Publishes certificate templates to specified or all Active Directory Certificate Services (ADCS) enrollment services.

## SYNTAX

### Name (Default)
```
Publish-ADCSTemplate [-Name] <String> [[-EnrollmentServices] <String[]>] [-Server <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### InputObject
```
Publish-ADCSTemplate [-InputObject] <Object> [[-EnrollmentServices] <String[]>] [-Server <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function adds the specified certificate templates to the list of templates that are published on the specified
ADCS enrollment services.
If no enrollment services are specified, the templates are published on all available
enrollment services.

## EXAMPLES

### EXAMPLE 1
```
Publish-ADCSTemplate -Name "User"
```

This example publishes the certificate template named "User" to all enrollment services.

### EXAMPLE 2
```
Publish-ADCSTemplate -Name "User" -EnrollmentServices "Issuing CA"
```

This example publishes the certificate template named "User" to the specified enrollment services.

## PARAMETERS

### -EnrollmentServices
Specifies the ADCS enrollment services to which the certificate templates will be published.
If not specified, the
function will publish the templates to all available enrollment services.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Specifies the certificate template object(s) to be published.

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
Specifies the name of the certificate template(s) to be published.

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
