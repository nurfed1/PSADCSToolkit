---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Get-ADCSTemplateEnrollmentService

## SYNOPSIS
Retrieves the enrollment services associated with an ADCS certificate template.

## SYNTAX

### Name (Default)
```
Get-ADCSTemplateEnrollmentService [-Name] <String> [-Server <String>] [<CommonParameters>]
```

### DisplayName
```
Get-ADCSTemplateEnrollmentService [-DisplayName] <String> [-Server <String>] [<CommonParameters>]
```

### InputObject
```
Get-ADCSTemplateEnrollmentService [-InputObject] <Object> [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-ADCSTemplateEnrollmentService\` function retrieves Active Directory Certificate Services (ADCS) enrollment services that are associated with a specified certificate template.
You can search by template name, display name, or provide an existing \`ADCSTemplate\` object.

## EXAMPLES

### EXAMPLE 1
```
Get-ADCSTemplateEnrollmentService -Name "WebServer"
```

Retrieves the enrollment services associated with the ADCS certificate template named "WebServer".

### EXAMPLE 2
```
Get-ADCSTemplateEnrollmentService -DisplayName "Web Server Authentication"
```

Retrieves the enrollment services associated with the ADCS certificate template that has the display name "Web Server Authentication".

### EXAMPLE 3
```
Get-ADCSTemplate -Name "WebServer" | Get-ADCSTemplateEnrollmentService
```

Retrieves the enrollment services for the "WebServer" template by piping the result of \`Get-ADCSTemplate\` into \`Get-ADCSTemplateEnrollmentService\`.

### EXAMPLE 4
```
Get-ADCSTemplateEnrollmentService -Name "User" -Server "CA01"
```

Retrieves the enrollment services associated with the "User" ADCS certificate template from the specified CA server "CA01".

## PARAMETERS

### -DisplayName
Specifies the display name of the ADCS certificate template(s) for which to retrieve associated enrollment services.
Supports wildcards.

```yaml
Type: System.String
Parameter Sets: DisplayName
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

### -InputObject
Specifies an \`ADCSTemplate\` object.
Enrollment services associated with the provided template object will be retrieved.

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
Specifies the name of the ADCS certificate template(s) for which to retrieve associated enrollment services.
Supports wildcards.

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
Specifies the ADCS server to query for template enrollment services.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject with type 'ADCSTemplateEnrollmentService'.
## NOTES

## RELATED LINKS
