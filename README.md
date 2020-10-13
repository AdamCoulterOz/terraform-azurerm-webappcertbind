## Additional Requirements

### PowerShell Dependencies

As this module uses PowerShell it requires that PowerShell Core and the following modules are installed on the deployment agent:

* PowerShell Core (~>7.0)
* PS Module: `AzureHelpers` (~>0.2.1)
* Please also install any dependencies of `AzureHelpers`

``` powershell
Install-Module @('AzureHelpers','Az.Websites')
```

## Usage Example

``` terraform
provider "shell" {
  environment = {
    AzureClientId     = var.client_id
    AzureTenantId     = var.tenant_id
    AzureSubscription = var.subscription_id
  }

  sensitive_environment = {
    AzureClientSecret = var.client_secret
  }

  interpreter = ["pwsh", "-Command"]
}

module "webappcertbind" {
  source            = "AdamCoulterOz/webappcert/azurerm"
  
  resource_group    = "myresourcegroup"
  web_app_name      = "mywebapp"
  thumbprint        = "B21111EXXXXXXXXXXXXXXX776F5E53CCCCCCB887"
}
```
