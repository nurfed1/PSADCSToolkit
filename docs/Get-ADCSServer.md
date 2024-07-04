---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# Get-ADCSServer

## SYNOPSIS
Retrieves ADCS (Active Directory Certificate Services) server information.

## SYNTAX

```
Get-ADCSServer [[-Name] <String>] [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves information about ADCS servers.
Allows filtering by server name and can target a specific Active Directory server for the query.

## EXAMPLES

### EXAMPLE 1
```
Get-ADCSServer -Server "dc01.domain.com"
```

Retrieves information about all ADCS servers from the specified Active Directory server "dc01.domain.com".

### EXAMPLE 2
```
Get-ADCSServer -Name "Root CA"
```

Retrieves information about the ADCS server named "Root CA".

## PARAMETERS

### -Name
Specifies the name of the ADCS server to retrieve.
If not provided, all ADCS servers are retrieved.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
```

### -Properties
Specifies specific properties of the ADCS server to retrieve.
Defaults to all properties defined in the ADCSServerPropertyMap.

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
Specifies the Active Directory server to connect to for retrieving ADCS server information.
If not provided, the default server is used.

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

### PSCustomObject with type 'ADCSServer'.
## NOTES

## RELATED LINKS
