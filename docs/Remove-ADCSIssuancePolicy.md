---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Remove-ADCSIssuancePolicy

## SYNOPSIS
Removes an ADCS issuance policy from Active Directory.

## SYNTAX

### Name (Default)
```
Remove-ADCSIssuancePolicy [-Name] <String> [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### DisplayName
```
Remove-ADCSIssuancePolicy [-DisplayName] <String> [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### InputObject
```
Remove-ADCSIssuancePolicy [-InputObject] <Object> [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function removes an ADCS (Active Directory Certificate Services) issuance policy based on the specified policy name, display name, or input object.

## EXAMPLES

### EXAMPLE 1
```
Remove-ADCSIssuancePolicy -Name "402.605C2ADE38A9344C83FA715663DB8821"
```

Removes the issuance policy with the specified Name using the default domain controller.

### EXAMPLE 2
```
Remove-ADCSIssuancePolicy -DisplayName "Policy Display Name"
```

Removes the issuance policy with the specified DisplayName using the default domain controller.

## PARAMETERS

### -DisplayName
Specifies the display name of the ADCS issuance policy to remove.

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
Specifies the input object representing the ADCS issuance policy to remove.

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
Specifies the name of the ADCS issuance policy to remove.

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
