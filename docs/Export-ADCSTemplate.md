---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Export-ADCSTemplate

## SYNOPSIS
Exports Active Directory Certificate Services (ADCS) certificate templates to JSON.

## SYNTAX

### Name (Default)
```
Export-ADCSTemplate [-Name] <String> [-ExportAcl] [-IncludePrincipalDomain] [-Server <String>]
 [<CommonParameters>]
```

### DisplayName
```
Export-ADCSTemplate [-DisplayName] <String> [-ExportAcl] [-IncludePrincipalDomain] [-Server <String>]
 [<CommonParameters>]
```

### InputObject
```
Export-ADCSTemplate [-InputObject] <Object> [-ExportAcl] [-IncludePrincipalDomain] [-Server <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves and exports ADCS certificate templates based on name, display name, or input object.
Optionally includes ACL and issuance policies in the export.

## EXAMPLES

### EXAMPLE 1
```
Export-ADCSTemplate -Name "WebServer"
```

Exports the ADCS certificate template with the name "WebServer" to JSON.

### EXAMPLE 2
```
Export-ADCSTemplate -DisplayName "Web Server Authentication"
```

Exports the ADCS certificate template with the display name "Web Server Authentication" to JSON.

### EXAMPLE 3
```
Get-ADCSTemplate -Name "UserTemplate" | Export-ADCSTemplate -IncludePrincipalDomain
```

Exports all ADCS certificate templates from the specified input objects to JSON.

### EXAMPLE 4
```
Export-ADCSTemplate -Name "WebServer" -ExportAcl -IncludePrincipalDomain
```

Exports the ADCS certificate template with the name "WebServer" to JSON, including ACL information with domain parts.

### EXAMPLE 5
```
mkdir ADCSTemplates -Force
```

PS C:\\\> cd ADCSTemplates
PS C:\\\> Export-ADCSTemplate | ForEach-Object {
PS C:\\\>     "Exporting $_.Name"
PS C:\\\>     $_ | Export-ADCSTemplate | Out-File -FilePath "$($_.Name).json" -Force
PS C:\\\> }

Export all templates to JSON.

## PARAMETERS

### -DisplayName
Specifies the display name of the ADCS certificate template to export.

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

### -ExportAcl
Indicates whether to include the ACLs in the exported template.

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
Indicates whether to include the domain part in the principal names in the ACLs.

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
Specifies an ADCSTemplate object from which to export properties.

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
Specifies the name of the ADCS certificate template to export.

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

### System.String - JSON representation of the ADCS template
## NOTES

## RELATED LINKS
