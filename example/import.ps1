

$templateDir = Join-Path -Path $PSScriptRoot -ChildPath templates

Get-ChildItem -Path "$($templateDir)\*.json" | ForEach-Object {
    $file = $_
    
    $name = $file.BaseName
    $json = (Get-Content -Path $file -Encoding utf8 -Raw) 
    
    New-ADCSTemplate -Name $name -Json $json -ImportAcl -Verbose -ErrorAction Ignore
}