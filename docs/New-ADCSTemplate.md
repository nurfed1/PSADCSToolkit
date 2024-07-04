---
external help file: PSADCSToolkit-help.xml
Module Name: PSADCSToolkit
online version:
schema: 2.0.0
---

# New-ADCSTemplate

## SYNOPSIS
Creates a new Active Directory Certificate Services template based on a Json export.
Any issuance policies associated with the template will also be created.

## SYNTAX

### JsonInput
```
New-ADCSTemplate [-Name] <String> -Json <String> [-ImportAcl] [-Publish] [-PassThru] [-Server <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ObjectInput
```
New-ADCSTemplate [-Name] <String> -InputObject <Object> [-ImportAcl] [-Publish] [-PassThru] [-Server <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-ADCSTemplate cmdlet creates a new certificate template in ADCS using the provided JSON data.
The cmdlet supports importing access control lists (ACLs) and issuing policies, and can publish the template to specified enrollment servers.

## EXAMPLES

### EXAMPLE 1
```
New-ADCSTemplate -Name "NewTemplate" -Json $templateJson
```

Creates a new certificate template named "NewTemplate" using the JSON data provided in $templateJson.

### EXAMPLE 2
```
New-ADCSTemplate -Name "NewTemplate" -Json $templateJson -Publish
```

Creates a new certificate template named "NewTemplate" and publishes it to all enrollment services.

### EXAMPLE 3
```
New-ADCSTemplate -Name "NewTemplate" -Json $templateJson -ImportAcl
```

Creates a new certificate template named "NewTemplate", imports the ACL from the JSON data.

### EXAMPLE 4
```
New-ADCSTemplate -Name "NewTemplate" -Json $templateJson -PassThru
```

Creates a new certificate template named "NewTemplate" and returns the created template object.

### EXAMPLE 5
```
New-ADCSTemplate -Name UserV2 -Json (Export-ADCSTemplate -Name UserV2)
```

## PARAMETERS

### -ImportAcl
Includes the access control list (ACL) in the created certificate template if specified.

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
Specifies the object representing the properties to update.

```yaml
Type: System.Object
Parameter Sets: ObjectInput
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Json
Specifies the JSON string that contains the properties of the certificate template to be created.

```yaml
Type: System.String
Parameter Sets: JsonInput
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name (CN) of the certificate template to create.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Returns the created certificate template object if specified.

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

### -Publish
Publish the template to all Certificate Authority issuers.
Use with caution in production environments.

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
Specifies the FQDN of the Active Directory Domain Controller to target for the operation.
If not specified, the nearest Domain Controller is used.

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

### PSCustomObject with type 'ADCSTemplate' - if the passthru parameter is set.
## NOTES

## RELATED LINKS
