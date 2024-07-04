#Requires -Modules platyPS

# Install-Module -Name platyPS

$scriptPath = Split-Path $MyInvocation.MyCommand.Path

$moduleName = 'PSADCSToolkit'
$markdownPath = Join-Path -Path $scriptPath -ChildPath '..\docs\' -Resolve

$mdHelpParams = @{
    Module                = $moduleName
    OutputFolder          = $markdownPath
    AlphabeticParamsOrder = $true
    UseFullTypeName       = $true
    WithModulePage        = $true
    ExcludeDontShow       = $false
    Encoding              = [System.Text.Encoding]::UTF8
}

New-MarkdownHelp @mdHelpParams -Force
