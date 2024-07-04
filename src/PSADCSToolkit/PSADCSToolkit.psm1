#requires -Version 5.0 -Modules ActiveDirectory
Set-StrictMode -Version 5.0

$scriptPath = Split-Path $MyInvocation.MyCommand.Path
# $ModuleName = $ExecutionContext.SessionState.Module

# Load functions
foreach ($scope in 'Classes', 'Public', 'Private', 'Exceptions') {
    Get-ChildItem (Join-Path -Path $scriptPath -ChildPath $scope) -Filter *.ps1 | ForEach-Object {
        . $_.FullName
        if ($scope -eq 'Public') {
            Export-ModuleMember -Function $_.BaseName -ErrorAction Stop
        }
    }
}

# Load global variables
$propertyMapPath = Join-Path -Path $scriptPath -ChildPath "PropertyMaps"

$ADCSIssuancePolicyPropertyMapPath = Join-Path -Path $propertyMapPath -ChildPath "ADCSIssuancePolicy.PropertyMap.ps1"
$script:ADCSIssuancePolicyPropertyMap = (. $ADCSIssuancePolicyPropertyMapPath).Properties

$ADCSEnrollmentServicePropertyMapPath = Join-Path -Path $propertyMapPath -ChildPath "ADCSEnrollmentService.PropertyMap.ps1"
$script:ADCSEnrollmentServicePropertyMap = (. $ADCSEnrollmentServicePropertyMapPath).Properties

$ADCSServerPropertyMapPath = Join-Path -Path $propertyMapPath -ChildPath "ADCSServer.PropertyMap.ps1"
$script:ADCSServerPropertyMap = (. $ADCSServerPropertyMapPath).Properties

$ADCSTemplatePropertyMapPath = Join-Path -Path $propertyMapPath -ChildPath "ADCSTemplate.PropertyMap.ps1"
$script:ADCSTemplatePropertyMap = (. $ADCSTemplatePropertyMapPath).Properties

# Add types
$ExportableTypes = @(
    # flags
    [ADCSTemplatePrivateKeyFlags]
    [ADCSTemplateCertificateNameFlags]
    [ADCSTemplateEnrollmentFlags]
    [ADCSTemplateKeySpecFlags]
    [ADCSTemplateFlags]

    # Exceptions
    [ADCSTemplateNotFoundException]
    [ADCSTemplateAlreadyExistsException]
    [ADCSServerNotFoundException]
    [ADCSEnrollmentServiceNotFoundException]
    [ADCSIssuancePolicyNotFoundException]
    [ADCSIssuancePolicyAlreadyExistsException]
    [ADCSIssuancePolicyInvalidOperationException]
)
# Get the internal TypeAccelerators class to use its static methods.
$TypeAcceleratorsClass = [psobject].Assembly.GetType(
    'System.Management.Automation.TypeAccelerators'
)
# Ensure none of the types would clobber an existing type accelerator.
# If a type accelerator with the same name exists, throw an exception.
$ExistingTypeAccelerators = $TypeAcceleratorsClass::Get
foreach ($Type in $ExportableTypes) {
    if ($Type.FullName -in $ExistingTypeAccelerators.Keys) {
        $Message = @(
            "Unable to register type accelerator '$($Type.FullName)'"
            'Accelerator already exists.'
        ) -join ' - '

        throw [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($Message),
            'TypeAcceleratorAlreadyExists',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $Type.FullName
        )
    }
}
# Add type accelerators for every exportable type.
foreach ($Type in $ExportableTypes) {
    $TypeAcceleratorsClass::Add($Type.FullName, $Type) | Out-Null
}

# Import types/format data
Update-TypeData -prependPath (Join-Path -Path $scriptPath -ChildPath 'PSADCSToolkit.Types.ps1xml')
Update-FormatData -PrependPath (Join-Path -Path $scriptPath -ChildPath 'PSADCSToolkit.Format.ps1xml')

# Cleanup when the module is removed.
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    # Remove type accelerators
    foreach ($Type in $ExportableTypes) {
        $TypeAcceleratorsClass::Remove($Type.FullName) | Out-Null
    }

    # Remove type data
    Remove-TypeData -Path (Join-Path -Path $scriptPath -ChildPath 'PSADCSToolkit.Types.ps1xml')
}.GetNewClosure()
