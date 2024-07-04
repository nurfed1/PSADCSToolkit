---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# New-ADCSDrive

## SYNOPSIS
Creates a PSDrive for accessing Active Directory Certificate Services (ADCS) configuration.

## SYNTAX

```
New-ADCSDrive [[-Server] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function creates a PSDrive named 'ADCS' to facilitate navigation and management of ADCS configuration
settings in Active Directory.
It imports the ActiveDirectory module and sets up the drive under the
'CN=Public Key Services,CN=Services' container in the ADCS configuration context.

## EXAMPLES

### EXAMPLE 1
```
New-ADCSDrive
```

PS C:\\\> Get-PSDrive
PS C:\\\> cd ADCS:

Navigates to the ADCS: drive.

## PARAMETERS

### -Server
Specifies the Active Directory server to connect to.
If not specified, uses the default server.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

### Microsoft.ActiveDirectory.Management.Provider.ADDriveInfo
### Returns the new PSDrive object.
## NOTES

## RELATED LINKS
