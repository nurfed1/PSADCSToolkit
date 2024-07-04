<#
.SYNOPSIS
Generates a random hexadecimal string of specified length.

.DESCRIPTION
This function creates a random hexadecimal string of the specified length.
It uses the characters '0123456789ABCDEF' to generate the random string.

.PARAMETER Length
Specifies the length of the hexadecimal string to generate. Must be a positive integer.

.OUTPUTS
System.String
Returns a string containing the randomly generated hexadecimal characters.

.EXAMPLE
PS C:\> Get-RandomHex -Length 8

Generates a random hexadecimal string of length 8, e.g. "3A7F1B5D".
#>
Function Get-RandomHex {
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.int32]$Length
    )

    process {
        $hex = '0123456789ABCDEF'
        $hexString = [System.Text.StringBuilder]::new()

        for ($i = 0; $i -lt $Length; $i++) {
            $randomChar = $hex[(Get-Random -Minimum 0 -Maximum $hex.Length)]
            $hexString.Append($randomChar) | Out-Null
        }

        Write-Output -InputObject $hexString.ToString()
    }
}