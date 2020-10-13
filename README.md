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
module "webapp_data" {
  source            = "AdamCoulterOz/webappcert/azurerm"
  
  resource_group    = "myresourcegroup"
  web_app_name      = "mywebapp"
  thumbprint        = "B21111EXXXXXXXXXXXXXXX776F5E53CCCCCCB887"

  client_id         = "00000000-0000-0000-0000-000000000002"
  client_secret     = "abc123"
  tenant_id         = "00000000-0000-0000-0000-000000000003"
  subscription_id   = "00000000-0000-0000-0000-000000000001"
}
```
