# vars from shell_script resource config
Test-Path $env:resource_group
Test-Path $env:web_app_name
Test-Path $env:thumbprint

Import-Module AzureHelpers

$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

Connect-Az -AuthMethod ClientSecret
$certificate = Get-AzWebAppCertificate -ResourceGroupName $env:resource_group -Thumbprint $env:thumbprint

function Read-CertBind {
    $result = Get-AzWebAppSSLBinding -ResourceGroupName $env:resource_group -WebAppName $env:web_app_name -Name $certificate.SubjectName
    
    if (([string]::IsNullOrEmpty($result)) -or ($result.Length -eq 0)) {
        Write-Error "Cert binding not found."
    }
    
    $output = @{ binding = $result.Name }
    $outputJson = ConvertTo-Json -InputObject $output -Depth 1
    Write-Output $outputJson
}
function New-CertBind {
    $result = New-AzWebAppSSLBinding -ResourceGroupName $env:resource_group -WebAppName $env:web_app_name -Name $certificate.SubjectName -SslState SniEnabled -Thumbprint $env:thumbprint
    Read-CertBind
}
function Remove-CertBind {
    Remove-AzWebAppSSLBinding -ResourceGroupName $env:resource_group -WebAppName $env:web_app_name -Name $certificate.SubjectName -DeleteCertificate $False -Force
}

function Set-CertBind {
    Remove-CertBind
    New-CertBind
}