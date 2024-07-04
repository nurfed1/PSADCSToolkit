#Requires -Modules platyPS

$scriptPath = Split-Path $MyInvocation.MyCommand.Path
$markdownPath = Join-Path -Path $scriptPath -ChildPath '..\docs\' -Resolve

$mdHelpParams = @{
    Path                  = $markdownPath
    #Module                = $moduleName
    #OutputFolder          = $markdownPath
    AlphabeticParamsOrder = $true
    UseFullTypeName       = $true
    UpdateInputOutput      = $true
    # WithModulePage        = $true
    ExcludeDontShow       = $false
    Encoding              = [System.Text.Encoding]::UTF8
}

Update-MarkdownHelp @mdHelpParams