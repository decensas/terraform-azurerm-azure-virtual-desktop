# azurerm-azure-virtual-desktop
Terraform module for deploying Azure Virtual Desktop. Deploys a single personal or shared host pool.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.8 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_role_assignment.admins](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.appgroup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.users](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_virtual_desktop_application_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) | resource |
| [azurerm_virtual_desktop_host_pool.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) | resource |
| [azurerm_virtual_desktop_host_pool_registration_info.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool_registration_info) | resource |
| [azurerm_virtual_desktop_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace) | resource |
| [azurerm_virtual_desktop_workspace_application_group_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) | resource |
| [azurerm_virtual_machine_extension.aad_join](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.hostpool_join](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_password.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_static.registration_token_expiration](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azuread_users.admins](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users) | data source |
| [azuread_users.users](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users) | data source |
| [azurerm_subscription.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_joined_allow_access_from_nonjoined"></a> [aad\_joined\_allow\_access\_from\_nonjoined](#input\_aad\_joined\_allow\_access\_from\_nonjoined) | Only applicable if using Azure AD authentication: adds a custom RDP property that allows access to the hosts from non-joined clients. | `bool` | `true` | no |
| <a name="input_avd_admins_object_ids"></a> [avd\_admins\_object\_ids](#input\_avd\_admins\_object\_ids) | Set of object IDs of the identites (Azure AD users or groups) who will be authorized to log into the VMs as local administrator. Useful if the identity running Terraform doesn't have Directory.Read-access to Azure AD or if you wish to assign a group, otherwise use var.avd\_admins\_upns. | `set(string)` | `[]` | no |
| <a name="input_avd_admins_upns"></a> [avd\_admins\_upns](#input\_avd\_admins\_upns) | Set of user principal names for the users who will be authorized to log into the VMs as local administrator. | `set(string)` | `[]` | no |
| <a name="input_avd_users_object_ids"></a> [avd\_users\_object\_ids](#input\_avd\_users\_object\_ids) | Set of object IDs of the identites (Azure AD users or groups) who will be authorized to log into the VMs as regular users. Useful if the identity running Terraform doesn't have Directory.Read-access to Azure AD or if you wish to assign a group, otherwise use var.avd\_users\_upns. | `set(string)` | `[]` | no |
| <a name="input_avd_users_upns"></a> [avd\_users\_upns](#input\_avd\_users\_upns) | Set of user principal names for the users who will be authorized to log into the VMs as regular users. | `set(string)` | `[]` | no |
| <a name="input_custom_rdp_properties"></a> [custom\_rdp\_properties](#input\_custom\_rdp\_properties) | Set of strings that will be added as custom RDP properties. E.g.: ["audiocapturemode:i:1", "audiomode:i:0"] | `set(string)` | `[]` | no |
| <a name="input_data_location"></a> [data\_location](#input\_data\_location) | The location to which metadata-resources will be deployed. This includes the host-pool, application group and workspace. Location of the virtual machines is defined by var.host\_location. See [Data locations for Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/data-locations). | `string` | n/a | yes |
| <a name="input_desktop_application_group_name_override"></a> [desktop\_application\_group\_name\_override](#input\_desktop\_application\_group\_name\_override) | Overrides the default name for the deskop application group. Defaults to `<var.system_name>-appgroup`. | `string` | `""` | no |
| <a name="input_host_location"></a> [host\_location](#input\_host\_location) | The location to which the hosts (VMs) will be deployed. | `string` | n/a | yes |
| <a name="input_host_pool_load_balancer_type"></a> [host\_pool\_load\_balancer\_type](#input\_host\_pool\_load\_balancer\_type) | Only applicable if var.host\_pool\_type is Pooled: Load balancing method used for new users sessions across the availiable hosts. Valid options are: `BreadthFirst`, `DepthFirst`. | `string` | `"BreadthFirst"` | no |
| <a name="input_host_pool_name_override"></a> [host\_pool\_name\_override](#input\_host\_pool\_name\_override) | Overrides the default name for the host pool. Defaults to `<var.system_name>-hostpool`. | `string` | `""` | no |
| <a name="input_host_pool_type"></a> [host\_pool\_type](#input\_host\_pool\_type) | The type of the host pool. Valid options are `Personal` or `Pooled` | `string` | n/a | yes |
| <a name="input_host_source_image_reference"></a> [host\_source\_image\_reference](#input\_host\_source\_image\_reference) | The reference to the operating system that will be used in the hosts. You can find this with [az cli](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage) or [PowerShell](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage). This should most likely be a variant of Windows 10/11 enterprise multi session-edition or Windows Server. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | <pre>{<br>  "offer": "windows-11",<br>  "publisher": "microsoftwindowsdesktop",<br>  "sku": "win11-21h2-avd",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_local_admin_password"></a> [local\_admin\_password](#input\_local\_admin\_password) | The password of the local admin account on the hosts. Defaults to generating a random password per host. This will be saved in state. | `string` | `""` | no |
| <a name="input_local_admin_username"></a> [local\_admin\_username](#input\_local\_admin\_username) | The username of the local admin account on the hosts. | `string` | `"azureuser"` | no |
| <a name="input_network_interface_name_format"></a> [network\_interface\_name\_format](#input\_network\_interface\_name\_format) | The format of the NIC names. The string is var.system\_name. The number is the NIC number. See [format-function](https://www.terraform.io/language/functions/format). | `string` | `"%s-nic%02d"` | no |
| <a name="input_number_of_hosts"></a> [number\_of\_hosts](#input\_number\_of\_hosts) | The number of hosts that will be deployed. | `number` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to deploy the AVD-resources. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to where the hosts will be deployed. Must be in the same region as var.host\_location. | `string` | n/a | yes |
| <a name="input_system_name"></a> [system\_name](#input\_system\_name) | The main name of the system. Will be used as a part of naming for multiple resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to all deployed resources. | `map(string)` | `{}` | no |
| <a name="input_virtual_machine_name_format"></a> [virtual\_machine\_name\_format](#input\_virtual\_machine\_name\_format) | The format of the VM names. The string is var.system\_name. The number is the VM number. See [format-function](https://www.terraform.io/language/functions/format). | `string` | `"%s-vm%02d"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the hosts. E.g. `Standard_D2s_v3`. See [Microsoft Docs: VM sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes). | `string` | n/a | yes |
| <a name="input_workspace_name_override"></a> [workspace\_name\_override](#input\_workspace\_name\_override) | Overrides the default name for the workspace. Defaults to `<var.system_name>-workspace`. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## :warning: Security note
>Be aware that the module sets role assignments on the resource group level. Meaning that *admins and users defined in the input variables will be given the same access to other VMs in the same resource group*.

## Features
 - [X] Azure AD authentication to hosts
 - [ ] Traditional AD authentication to hosts
 - [ ] Autoscaling