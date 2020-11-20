# vars from shell_script resource config
Test-Path $env:resource_group
Test-Path $env:web_app_name
Test-Path $env:thumbprint
Test-Path $env:custom_fqdn

Import-Module AzureHelpers

$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

function Invoke-AzAPI {
   [CmdletBinding()]
    param([string]$method,[string]$body="",[string]$URL)
    $token = Get-AzToken -AuthMethod ClientSecret
    $secure_token = ConvertTo-SecureString $token -AsPlainText -Force
    Write-Error "About to Invoke-RestMethod $URL..." -ErrorAction 'Continue'
    $result = Invoke-RestMethod -Method $method -Uri $URL -Authentication Bearer -Token $secure_token -Body $body -ContentType 'application/json'
    Write-Error "AzAPI Result: $(ConvertTo-Json $result)" -ErrorAction 'Continue'
    return $result
}

Connect-Az -AuthMethod ClientSecret

function Read-CertBind {
    $result = Get-AzWebAppSSLBinding -ResourceGroupName $env:resource_group -WebAppName $env:web_app_name -Name $env:custom_fqdn
    
    if (([string]::IsNullOrEmpty($result)) -or ($result.Length -eq 0)) {
        Write-Error "Cert binding not found." -ErrorAction 'Continue'
        return $Null
    }
    
    $output = @{ binding = $result.Name }
    $outputJson = ConvertTo-Json -InputObject $output -Depth 1
    Write-Output $outputJson
}
function New-CertBind {
    Write-Error "New-CertBind: resource group $env:resource_group" -ErrorAction 'Continue'
    Write-Error "New-CertBind: web app name $env:web_app_name" -ErrorAction 'Continue'
    Write-Error "New-CertBind: thumbprint $env:thumbprint" -ErrorAction 'Continue'
    Write-Error "New-CertBind: custom_fqdn $env:custom_fqdn" -ErrorAction 'Continue'
    $body = ConvertTo-Json @{
        "properties"= @{
            "siteName" = $env:web_app_name;
            "sslState" = "SniEnabled";
            "thumbprint" = $env:thumbprint
        }
    }
    Write-Error "New-CertBind: Sending body`n$body" -ErrorAction 'Continue'
    $URL = "https://management.azure.com/subscriptions/$env:AzureSubscription/resourceGroups/$env:resource_group/providers/Microsoft.Web/sites/$env:web_app_name/hostNameBindings/$($env:custom_fqdn)?api-version=2019-08-01"
    Write-Error "URL: $URL" -ErrorAction 'Continue'
    $result = Invoke-AzAPI -method 'PUT' -URL $URL -body $body
    Write-Error "Response from PUT: $(ConvertTo-Json $result)" -ErrorAction 'Continue'
    Read-CertBind
}
function Remove-CertBind {
    Remove-AzWebAppSSLBinding -ResourceGroupName $env:resource_group -WebAppName $env:web_app_name -Name $env:cert_name -DeleteCertificate $False -Force
    Read-CertBind
}

function Set-CertBind {
    Remove-CertBind
    New-CertBind
}
