---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Get-ADCSTemplateDacl

## SYNOPSIS
Retrieves the discretionary access control list (DACL) for an ADCS certificate template.

## SYNTAX

```
Get-ADCSTemplateDacl [-Name] <String> [-Server <String>] [-Detailed] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the DACL for a specified Active Directory Certificate Services (ADCS) certificate template.
Depending on the \`-Detailed\` switch parameter, it either summarizes the permissions per principal or provides detailed
information about each access control entry (ACE) in the DACL.

## EXAMPLES

### EXAMPLE 1
```
Get-ADCSTemplateDacl -Name "User" -Detailed
```

Retrieves detailed DACL information for the ADCS certificate template with the name "User".

### EXAMPLE 2
```
Get-ADCSTemplateDacl -Name "User"
```

Retrieves DACL information for the ADCS certificate template with the name "User".

## PARAMETERS

### -Detailed
Switch parameter.
If specified, provides detailed information about each ACE in the DACL.

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

### -Name
Specifies the name of the ADCS certificate template.

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

### -Server
Specifies the Active Directory server to connect to.

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

### System.Object
### Returns custom objects representing DACL information. For `-Detailed` mode, includes Type, Principal, Rights, and Property.
### For standard mode, includes Principal, AllowPermissions, and DenyPermissions.
## NOTES

## RELATED LINKS
