
# dotnet nuget list source
# dotnet nuget add source --name nuget.org https://api.nuget.org/v3/index.json

# New-Item -Path C:\modules\ -Type Directory
# Register-PSRepository -Name 'PsRepo' -SourceLocation 'C:\modules\' -InstallationPolicy Trusted

$scriptPath = Split-Path $MyInvocation.MyCommand.Path
$modulePath = Join-Path -Path $scriptPath -ChildPath '..\src\PSADCSToolkit\' -Resolve

Publish-Module -Path $modulePath -Repository PsRepo -Verbose -Force

# Install-Module -Name PSADCSToolkit -Repository PsRepo
