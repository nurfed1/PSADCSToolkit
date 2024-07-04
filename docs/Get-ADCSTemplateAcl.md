---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Get-ADCSTemplateAcl

## SYNOPSIS
Retrieves Access Control Lists (ACLs) for Active Directory Certificate Services (ADCS) certificate templates.

## SYNTAX

### Name (Default)
```
Get-ADCSTemplateAcl [-Name] <String> [-IncludePrincipalDomain] [-ExcludeInheritedAce] [-Server <String>]
 [<CommonParameters>]
```

### DisplayName
```
Get-ADCSTemplateAcl [-DisplayName] <String> [-IncludePrincipalDomain] [-ExcludeInheritedAce] [-Server <String>]
 [<CommonParameters>]
```

### InputObject
```
Get-ADCSTemplateAcl [-InputObject] <Object> [-IncludePrincipalDomain] [-ExcludeInheritedAce] [-Server <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves ACLs for ADCS certificate templates based on name, display name, or input object.
Converts principal names and resolves schema rights for each ACL entry.

## EXAMPLES

### EXAMPLE 1
```
Get-ADCSTemplateAcl -Name "WebServer"
```

Retrieves ACLs for the ADCS certificate template named "WebServer".

### EXAMPLE 2
```
Get-ADCSTemplateAcl -DisplayName "Web Server Authentication"
```

Retrieves ACLs for the ADCS certificate template with the display name "Web Server Authentication".

### EXAMPLE 3
```
Get-ADCSTemplate -Name "UserTemplate" | Get-ADCSTemplateAcl -IncludePrincipalDomain
```

Retrieves ACLs for the ADCS certificate template named "WebServer" and includes the domain part of the principal names in the output.

## PARAMETERS

### -DisplayName
Specifies the display name of the ADCS certificate template to retrieve ACLs for.

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

### -ExcludeInheritedAce
Exclude inherited Dacl and Sacl aces in the output.

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
Switch parameter to include the domain part in principal names.

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
Specifies an ADCSTemplate object from which to retrieve ACLs.

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
Specifies the name of the ADCS certificate template to retrieve ACLs for.

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

### PSCustomObject with type 'ADCSTemplateAcl'.
## NOTES

## RELATED LINKS
