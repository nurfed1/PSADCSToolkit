---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Get-ADCSEnrollmentService

## SYNOPSIS
Retrieves information about ADCS (Active Directory Certificate Services) Enrollment Servers.

## SYNTAX

### Name (Default)
```
Get-ADCSEnrollmentService [[-Name] <String>] [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
```

### DisplayName
```
Get-ADCSEnrollmentService [[-DisplayName] <String>] [-Properties <String[]>] [-Server <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This function retrieves information about ADCS Enrollment Servers from Active Directory.
You can filter the results by Name or DisplayName, and specify a particular Active Directory server to query.

## EXAMPLES

### EXAMPLE 1
```
Get-ADCSEnrollmentService -Server "dc01.domain.com"
```

Retrieves information about all ADCS Enrollment Servers from the specified Active Directory server "dc01.domain.com".

### EXAMPLE 2
```
Get-ADCSEnrollmentService -Name "Issuing CA"
```

Retrieves information about the ADCS Enrollment Server named "Issuing CA".

### EXAMPLE 3
```
Get-ADCSEnrollmentService -DisplayName "Issuing CA"
```

Retrieves information about the ADCS Enrollment Server with the display name "Issuing CA".

## PARAMETERS

### -DisplayName
Specifies the display name of the ADCS Enrollment Server to retrieve.

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

### -Name
Specifies the name of the ADCS Enrollment Server to retrieve.

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
Specifies specific properties of the ADCS enrollment service to retrieve.
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
Specifies the Active Directory server to connect to for retrieving ADCS Enrollment Server information.

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

### PSCustomObject with type 'ADCSEnrollmentService'.
## NOTES

## RELATED LINKS
