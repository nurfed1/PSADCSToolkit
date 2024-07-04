---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Get-ADCSIssuancePolicy

## SYNOPSIS
Retrieves ADCS (Active Directory Certificate Services) issuance policies.

## SYNTAX

### Name (Default)
```
Get-ADCSIssuancePolicy [[-Name] <String>] [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
```

### DisplayName
```
Get-ADCSIssuancePolicy [[-DisplayName] <String>] [-Properties <String[]>] [-Server <String>]
 [<CommonParameters>]
```

### Oid
```
Get-ADCSIssuancePolicy [[-Oid] <String>] [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
```

### InputObject
```
Get-ADCSIssuancePolicy [-InputObject] <Object> [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves ADCS issuance policies based on name, display name, OID, or input object.
Optionally, specific properties can be requested, and a specific server can be targeted.

## EXAMPLES

### EXAMPLE 1
```
Get-ADCSIssuancePolicy
```

Retrieves all ADCS issuance policies.

### EXAMPLE 2
```
Get-ADCSIssuancePolicy -Name "PolicyName"
```

Retrieves the ADCS issuance policy with the name "PolicyName".

### EXAMPLE 3
```
Get-ADCSIssuancePolicy -DisplayName "Policy Display Name"
```

Retrieves the ADCS issuance policy with the display name "Policy Display Name".

### EXAMPLE 4
```
Get-ADCSIssuancePolicy -Oid "1.3.6.1.4.1.311.21.8.2367620.13778790.8537997.8704753.4613409.108.69759536.19157042"
```

Retrieves the ADCS issuance policy with the OID "1.3.6.1.4.1.311.21.8.2367620.13778790.8537997.8704753.4613409.108.69759536.19157042".

## PARAMETERS

### -DisplayName
Specifies the display name of the ADCS issuance policy to retrieve.

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
Specifies an ADCSIssuancePolicy object from which to retrieve properties.

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
Specifies the name of the ADCS issuance policy to retrieve.

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

### -Oid
Specifies the OID of the ADCS issuance policy to retrieve.

```yaml
Type: System.String
Parameter Sets: Oid
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

### -Properties
Specifies specific properties of the ADCS issuance policy to retrieve.
Defaults to all properties defined in the ADCSIssuancePolicyPropertyMap.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: All Properties
Accept pipeline input: False
Accept wildcard characters: False
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

### PSCustomObject with type 'ADCSIssuancePolicy'.
## NOTES

## RELATED LINKS
