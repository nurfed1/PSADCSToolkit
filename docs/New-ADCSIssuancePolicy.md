---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# New-ADCSIssuancePolicy

## SYNOPSIS
Creates a new ADCS issuance policy in Active Directory.

## SYNTAX

### NameJson (Default)
```
New-ADCSIssuancePolicy [-Name] <String> -Json <String> [-PassThru] [-Server <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### NameInput
```
New-ADCSIssuancePolicy [-Name] <String> -InputObject <Object> [-PassThru] [-Server <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### DisplayNameInput
```
New-ADCSIssuancePolicy [-DisplayName] <String> -InputObject <Object> [-PassThru] [-Server <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### DisplayNameJson
```
New-ADCSIssuancePolicy [-DisplayName] <String> -Json <String> [-PassThru] [-Server <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function creates a new ADCS (Active Directory Certificate Services) issuance policy based on the provided parameters.
It supports creating policies either by specifying a policy name or display name and a JSON configuration or an input object.

## EXAMPLES

### EXAMPLE 1
```
New-ADCSIssuancePolicy -Name "402.605C2ADE38A9344C83FA715663DB8821" -Json (Get-Content policy.Json -Raw)
```

Creates a new issuance policy with the specified Name  and the provided JSON data.

### EXAMPLE 2
```
New-ADCSIssuancePolicy -DisplayName "Policy Name" -Json (Export-ADCSIssuancePolicy -Name SomePolicy)
```

Creates a new issuance policy with the specified DisplayName and the provided JSON data.

## PARAMETERS

### -DisplayName
Specifies the display name of the ADCS issuance policy.

```yaml
Type: System.String
Parameter Sets: DisplayNameInput, DisplayNameJson
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Specifies the input object representing the ADCS issuance policy configuration.

```yaml
Type: System.Object
Parameter Sets: NameInput, DisplayNameInput
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Json
Specifies the JSON representation of the ADCS issuance policy configuration.

```yaml
Type: System.String
Parameter Sets: NameJson, DisplayNameJson
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the OID (Object Identifier) of the ADCS issuance policy.
The name should match the pattern '^\d+\.\[0-9a-fA-F\]{32}$'.

```yaml
Type: System.String
Parameter Sets: NameJson, NameInput
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Indicates that the created ADCS issuance policy object should be passed through the pipeline.

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

### PSCustomObject with type 'ADCSIssuancePolicy' - if the passthru parameter is set.
## NOTES

## RELATED LINKS
