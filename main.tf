resource "shell_script" "app_service_cert_bind" {
  environment = {
    thumbprint     = var.thumbprint
    resource_group = var.resource_group
    web_app_name   = var.web_app_name
  }
  
  lifecycle_commands {
    create = ". ${path.module}/CertBind.ps1; New-CertBind"
    read   = ". ${path.module}/CertBind.ps1; Read-CertBind"
    update = ". ${path.module}/CertBind.ps1; Set-CertBind"
    delete = ". ${path.module}/CertBind.ps1; Remove-CertBind"
  }
}
