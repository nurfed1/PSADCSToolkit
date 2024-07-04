---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Get-ADCSTemplate

## SYNOPSIS
Retrieves Active Directory Certificate Services (ADCS) certificate templates.

## SYNTAX

### Name (Default)
```
Get-ADCSTemplate [[-Name] <String>] [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
```

### DisplayName
```
Get-ADCSTemplate [[-DisplayName] <String>] [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
```

### InputObject
```
Get-ADCSTemplate [-InputObject] <Object> [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves ADCS certificate templates based on name, display name, or input object.

## EXAMPLES

### EXAMPLE 1
```
Get-ADCSTemplate
```

Retrieves all ADCS certificate templates.

### EXAMPLE 2
```
Get-ADCSTemplate -Name "WebServer"
```

Retrieves the ADCS certificate template with the name "WebServer".

### EXAMPLE 3
```
Get-ADCSTemplate -DisplayName "Web Server Authentication"
```

Retrieves the ADCS certificate template with the display name "Web Server Authentication".

### EXAMPLE 4
```
Get-ADCSTemplate -Properties Name, Created, Modified | Sort-Object Name | ft
```

Retrieves the Created and Modified properties of all ADCS certificate templates.

## PARAMETERS

### -DisplayName
Specifies the display name of the ADCS certificate template(s) to retrieve.

```yaml
Type: System.String
Parameter Sets: DisplayName
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

### -InputObject
Specifies an ADCSTemplate object from which to retrieve properties.

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
Specifies the name of the ADCS certificate template(s) to retrieve.

```yaml
Type: System.String
Parameter Sets: Name
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
```

### -Properties
Specifies specific properties of the ADCS certificate template to retrieve.
Defaults to all properties defined in the ADCSTemplatePropertyMap.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: All Properties
Accept pipeline input: False
Accept wildcard characters: True
```

### -Server
Specifies the server to connect to for retrieving ADCS information.

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

### PSCustomObject with type 'ADCSTemplate'.
## NOTES

## RELATED LINKS
