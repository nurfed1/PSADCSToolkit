

$templateDir = Join-Path -Path $PSScriptRoot -ChildPath exports

if(-not (Test-Path -Path $TemplateDir)) {
    Write-Error -Message "Template directory '$TemplateDir' does not exist."
    return
}


Get-ADCSTemplate | ForEach-Object {
    $template = $_

    $templatePath = Join-Path -Path $templateDir -ChildPath  "$($template.Name).json"
    
    $json = $template | Export-ADCSTemplate -ExportAcl -Verbose | jq.exe -r
    
    if ($IsCoreCLR) {
        $json | Out-File -FilePath $templatePath -Encoding utf8NoBOM -Force
    }
    else {
        Set-Content -Path $templatePath -Value ([byte[]][char[]]($json -join "`n")) -Encoding Byte
    }
}
