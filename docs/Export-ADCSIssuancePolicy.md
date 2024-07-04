---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Export-ADCSIssuancePolicy

## SYNOPSIS
Exports the ADCS issuance policies to JSON format.

## SYNTAX

### Name (Default)
```
Export-ADCSIssuancePolicy [-Name] <String> [-Server <String>] [<CommonParameters>]
```

### DisplayName
```
Export-ADCSIssuancePolicy [-DisplayName] <String> [-Server <String>] [<CommonParameters>]
```

### InputObject
```
Export-ADCSIssuancePolicy [-InputObject] <Object> [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
This function exports the specified ADCS issuance policies to JSON format.
It supports exporting by policy name,
display name, or directly from an input object.

## EXAMPLES

### EXAMPLE 1
```
Export-ADCSIssuancePolicy -Name '29.74933F91AB47F116CEC3207E23EB1B18'
```

This example exports the issuance policy named '29.74933F91AB47F116CEC3207E23EB1B18' to JSON format.

### EXAMPLE 2
```
Export-ADCSIssuancePolicy -DisplayName 'User Policy'
```

This example exports the issuance policy with the display name 'User Policy' to JSON format.

### EXAMPLE 3
```
mkdir ADCSPolicies -Force
```

PS C:\\\> cd ADCSPolicies
PS C:\\\> Get-ADCSIssuancePolicy | ForEach-Object {
PS C:\\\>     "Exporting $_.Name"
PS C:\\\>     $_ | Export-ADCSIssuancePolicy | Out-File -FilePath "$($_.Name).json" -Force
PS C:\\\> }

Export all issuance policies to JSON.

## PARAMETERS

### -DisplayName
Specifies the display name of the issuance policy to export.

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
Specifies the issuance policy object to export.

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
Specifies the name of the issuance policy to export.

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

### System.String - JSON representation of the ADCS issuance policy
## NOTES

## RELATED LINKS
