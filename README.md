# azurerm-azure-virtual-desktop
Terraform module for deploying Azure Virtual Desktop. Deploys a signle personal or shared host pool.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_desktop_application_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) | resource |
| [azurerm_virtual_desktop_host_pool.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) | resource |
| [azurerm_virtual_desktop_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace) | resource |
| [azurerm_virtual_desktop_workspace_application_group_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_joined_allow_access_from_nonjoined"></a> [aad\_joined\_allow\_access\_from\_nonjoined](#input\_aad\_joined\_allow\_access\_from\_nonjoined) | Only applicable if using Azure AD authentication: adds a custom RDP property that allows access to the hosts from non-joined clients. | `bool` | `true` | no |
| <a name="input_custom_rdp_properties"></a> [custom\_rdp\_properties](#input\_custom\_rdp\_properties) | Set of strings that will be added as custom RDP properties. E.g.: ["audiocapturemode:i:1", "audiomode:i:0"] | `set(string)` | `[]` | no |
| <a name="input_data_location"></a> [data\_location](#input\_data\_location) | The location to which metadata-resources will be deployed. This includes the host-pool, application group and workspace. Location of the virtual machines is defined by var.host\_location. See [Data locations for Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/data-locations). | `string` | n/a | yes |
| <a name="input_desktop_application_group_name_override"></a> [desktop\_application\_group\_name\_override](#input\_desktop\_application\_group\_name\_override) | Overrides the default name for the deskop\_application\_group. Defaults to `<var.system_name>-appgroup`. | `string` | `""` | no |
| <a name="input_host_location"></a> [host\_location](#input\_host\_location) | The location to which the hosts (VMs) will be deployed. | `string` | n/a | yes |
| <a name="input_host_pool_load_balancer_type"></a> [host\_pool\_load\_balancer\_type](#input\_host\_pool\_load\_balancer\_type) | Only applicable if var.host\_pool\_type is Pooled: Load balancing method used for new users sessions across the availiable hosts. Valid options are: `BreadthFirst`, `DepthFirst`. | `string` | `"BreadthFirst"` | no |
| <a name="input_host_pool_name_override"></a> [host\_pool\_name\_override](#input\_host\_pool\_name\_override) | Overrides the default name for the host pool. Defaults to `<var.system_name>-hostpool`. | `string` | `""` | no |
| <a name="input_host_pool_type"></a> [host\_pool\_type](#input\_host\_pool\_type) | The type of the host pool. Valid options are `Personal` or `Pooled` | `string` | n/a | yes |
| <a name="input_number_of_hosts"></a> [number\_of\_hosts](#input\_number\_of\_hosts) | The number of hosts that will be deployed. | `number` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to deploy the AVD-resources. | `string` | n/a | yes |
| <a name="input_system_name"></a> [system\_name](#input\_system\_name) | The main name of the system. Will be used as a part of naming for multiple resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to all deployed resources. | `map(string)` | `{}` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the hosts. E.g. `Standard_D2s_v3`. | `string` | n/a | yes |
| <a name="input_workspace_name_override"></a> [workspace\_name\_override](#input\_workspace\_name\_override) | Overrides the default name for the workspace. Defaults to `<var.system_name>-workspace`. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Features
 - [X] Azure AD authentication to hosts
 - [ ] Traditional AD authentication to hosts
 - [ ] Autoscaling