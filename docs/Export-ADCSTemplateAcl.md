---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Export-ADCSTemplateAcl

## SYNOPSIS
Exports the ACL of ADCS templates to JSON format.

## SYNTAX

### Name (Default)
```
Export-ADCSTemplateAcl [-Name] <String> [-IncludePrincipalDomain] [-IncludeInheritedAce] [-Server <String>]
 [<CommonParameters>]
```

### DisplayName
```
Export-ADCSTemplateAcl [-DisplayName] <String> [-IncludePrincipalDomain] [-IncludeInheritedAce]
 [-Server <String>] [<CommonParameters>]
```

### InputObject
```
Export-ADCSTemplateAcl [-InputObject] <Object> [-IncludePrincipalDomain] [-IncludeInheritedAce]
 [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
This function exports the Access Control List (ACL) of the specified ADCS templates to JSON format.

## EXAMPLES

### EXAMPLE 1
```
Export-ADCSTemplateAcl -Name 'User'
```

This example exports the ACL of the ADCS template named 'User' to JSON format.

### EXAMPLE 2
```
Export-ADCSTemplateAcl -DisplayName 'User Template'
```

This example exports the ACL of the ADCS template with the display name 'User Template' to JSON format.

### EXAMPLE 3
```
Export-ADCSTemplateAcl -Name 'UserTemplate' -IncludePrincipalDomain
```

This example exports the ACL of the ADCS template named 'UserTemplate' to JSON format, including principal domain information.

## PARAMETERS

### -DisplayName
Specifies the display name of the ADCS template whose ACL is to be exported.

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

### -IncludeInheritedAce
Includes inherited Dacl and Sacl aces in the output.

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

### -IncludePrincipalDomain
Includes the principal domain information in the output.

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
Specifies the ADCS template ACL object to be exported.

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
Specifies the name of the ADCS template whose ACL is to be exported.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String - JSON representation of the ADCS template ACL
## NOTES

## RELATED LINKS
