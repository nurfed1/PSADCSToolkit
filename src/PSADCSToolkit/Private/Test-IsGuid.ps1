<#
.SYNOPSIS
Tests if a given string is a valid GUID (Globally Unique Identifier).

.DESCRIPTION
This function checks if the provided string matches the standard GUID format using a regular expression.

.PARAMETER GuidString
Specifies the string to check for GUID format validity. The string should be a valid GUID.

.OUTPUTS
System.Boolean
Returns $true if the string is a valid GUID, otherwise returns $false.

.EXAMPLE
PS C:\> Test-IsGuid -GuidString "123e4567-e89b-12d3-a456-426614174000"

Checks if the string "123e4567-e89b-12d3-a456-426614174000" is a valid GUID. Returns $true.

.EXAMPLE
PS C:\> Test-IsGuid -GuidString "{123e4567-e89b-12d3-a456-426614174000}"

Checks if the string "{123e4567-e89b-12d3-a456-426614174000}" is a valid GUID. Returns $true.

.EXAMPLE
PS C:\> Test-IsGuid -GuidString "invalid-guid-string"

Checks if the string "invalid-guid-string" is a valid GUID. Returns $false.
#>
function Test-IsGuid {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$GuidString
    )

    process {
        $guidRegex = '^(\{){0,1}[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}(\}){0,1}$'

        Write-Output -InputObject ($GuidString -match $guidRegex)
    }
}