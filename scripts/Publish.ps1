
param (
    [Parameter(Mandatory = $false, HelpMessage = "Publish the module locally.")]
    [switch]$Local,

    [Parameter(Mandatory = $false, HelpMessage = "Publish the module to NuGet with the provided API key.")]
    [ValidateNotNullOrEmpty()]
    [System.String]$NuGetApiKey
)


$scriptPath = Split-Path $MyInvocation.MyCommand.Path
$modulePath = Join-Path -Path $scriptPath -ChildPath '..\src\PSADCSToolkit\' -Resolve

$repoPath = "C:\modules\"

# Publish the module based on parameters
if ($Local) {
    Write-Host "Publishing module locally..."

    # dotnet nuget list source
    # dotnet nuget add source --name nuget.org https://api.nuget.org/v3/index.json

    if (!(Test-Path -Path $repoPath)) {
        New-Item -Path $repoPath -Type Directory | Out-Null
    }

    if (!(Get-PSRepository -Name "PsRepo" -ErrorAction SilentlyContinue)) {
        Register-PSRepository -Name 'PsRepo' -SourceLocation $repoPath -InstallationPolicy Trusted
    }

    Publish-Module -Path $modulePath -Repository PsRepo -Verbose -Force

    # Install-Module -Name PSADCSToolkit -Repository PsRepo
} elseif ($NuGetApiKey) {
    Write-Host "Publishing module to NuGet repository..."
    Publish-Module -Path $modulePath -NuGetApiKey $NuGetApiKey -Verbose -Force
} else {
    Write-Host "No valid parameters provided. Use -Local or -NuGetApiKey." -ForegroundColor Yellow
}