#Requires -Modules PSDesiredStateConfiguration, PSADCSToolkit


Configuration ADCSTemplateConfiguration {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo[]] $Templates,
        
        [Parameter(Mandatory = $true)]
        [System.String[]] $EnrollmentServices,
        
        [Parameter(Mandatory = $false)]
        [System.Boolean] $ImportAcl = $true,
                
        [Parameter(Mandatory = $true)]
        [PSCredential] $DomainCredential

    )

    Import-DscResource -ModuleName PSADCSToolkit -Name COMMUNITY_ADCSTemplate

    Node localhost {

        $Templates | ForEach-Object {
            $file = $_
    
            $name = $file.BaseName
            $json = (Get-Content -Path $file -Encoding utf8 -Raw) 
    
            ADCSTemplate "Template_$($name)" {
                Ensure               = 'Present'
                Name                 = $name
                Json                 = $json
                ImportAcl            = $ImportAcl
                EnrollmentServices   = $EnrollmentServices
                PsDscRunAsCredential = $DomainCredential
            }        
        }
    }
}


$configurationData = @{
    AllNodes = @(
        @{
            NodeName                    = 'localhost'
            PSDscAllowDomainUser        = $true
            PSDscAllowPlainTextPassword = $true
        }
    )
}

$outputPath = Get-Location | Select-Object -ExpandProperty Path
$templateDir = Join-Path -Path $PSScriptRoot -ChildPath templates

$templates = Get-ChildItem -Path "$($templateDir)\*.json"

$enrollmentServices = @("Test Lab Issuing CA")
$username = "test.lab\automation"
$password = "password" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $password)

$params = @{
    OutputPath         = $outputPath
    ConfigurationData  = $configurationData
    Templates          = $templates
    EnrollmentServices = $enrollmentServices
    DomainCredential   = $credential
}

ADCSTemplateConfiguration @params

Start-DscConfiguration -Path $OutputPath -Wait -Verbose

Test-DscConfiguration -Path $OutputPath -Verbose
