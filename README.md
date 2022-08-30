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
| [azurerm_virtual_desktop_host_pool.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_joined_allow_access_from_nonjoined"></a> [aad\_joined\_allow\_access\_from\_nonjoined](#input\_aad\_joined\_allow\_access\_from\_nonjoined) | Only applicable if using Azure AD authentication: adds a custom RDP property that allows access to the hosts from non-joined clients. | `bool` | `true` | no |
| <a name="input_data_location"></a> [data\_location](#input\_data\_location) | The location to which metadata-resources will be deployed. This includes the host-pool, application group and workspace. Location of the virtual machines is defined by var.host\_location. See [Data locations for Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/data-locations). | `string` | n/a | yes |
| <a name="input_host_location"></a> [host\_location](#input\_host\_location) | The location to which the hosts (VMs) will be deployed. | `string` | n/a | yes |
| <a name="input_host_pool_load_balancer_type"></a> [host\_pool\_load\_balancer\_type](#input\_host\_pool\_load\_balancer\_type) | Load balancing method used for new users sessions across the availiable hosts. Must be `Persistent` if var.host\_pool\_type is `Personal`. Valid options are `BreadthFirst`, `DepthFirst` or `Persistent`. | `string` | n/a | yes |
| <a name="input_host_pool_name_override"></a> [host\_pool\_name\_override](#input\_host\_pool\_name\_override) | Overrides the default name for the host pool. Defaults to `<var.system_name>-hostpool`. | `string` | `""` | no |
| <a name="input_host_pool_type"></a> [host\_pool\_type](#input\_host\_pool\_type) | The type of the host pool. Valid options are `Personal` or `Pooled` | `string` | n/a | yes |
| <a name="input_number_of_host"></a> [number\_of\_host](#input\_number\_of\_host) | The number of hosts that will be deployed. | `number` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to deploy the AVD-resources. | `string` | n/a | yes |
| <a name="input_system_name"></a> [system\_name](#input\_system\_name) | The main name of the system. Will be used as a part of naming for multiple resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to all deployed resources. | `map(string)` | `{}` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the hosts. E.g. `Standard_D2s_v3`. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Features
 - [X] Azure AD authentication to hosts
 - [ ] Traditional AD authentication to hosts
 - [ ] Autoscaling