# azurerm-azure-virtual-desktop
Terraform module for deploying Azure Virtual Desktop. Deploys a single personal or shared host pool.

## Examples
Here are some short examples with referenced resources cut out. See [examples](./examples)-directory for full examples.

### Shared hosts with user-assignments
This method is useful if you want each user to have their own assignment and you want to maintain access with Terraform. [Full example here](./examples/user-assigned-shared/main.tf).
```terraform
module "avd" {
  source  = "decensas/azure-virtual-desktop/azurerm"
  version = "0.1.2"

  system_name         = "avd"
  resource_group_name = azurerm_resource_group.main.name
  data_location       = azurerm_resource_group.main.location
  host_location       = azurerm_resource_group.main.location

  vm_size                      = "Standard_D2s_v3"
  number_of_hosts              = 3
  host_pool_type               = "Pooled"
  host_pool_load_balancer_type = "BreadthFirst"

  avd_users_upns  = ["user1@domain.com", "user2@domain.com"]
  avd_admins_upns = ["admin@domain.com"]

  workspace_friendly_name = "User assigned shared hosts"

  subnet_id = azurerm_subnet.main.id
}
```

### Shared hosts with group-assignments
This method is useful if you have Azure AD groups that you want to assign as users and admins, giving you the possibility to add assignments manually. [Full example here](./examples/groups-assigned-shared/main.tf).

A variation of this can also be used where you enter object ids directly into `avd_users_object_ids` and `avd_admins_object_ids`. This is useful if Terraform doesn't have Directory.Read-access to Azure AD.

>Note that the values of `avd_users_object_ids` and `avd_admins_object_ids` must already be known to Terraform at apply, meaning they can't depend on resources being deployed in the same step.
```terraform
module "avd" {
  source  = "decensas/azure-virtual-desktop/azurerm"
  version = "0.1.2"

  system_name         = "avd"
  resource_group_name = azurerm_resource_group.main.name
  data_location       = azurerm_resource_group.main.location
  host_location       = azurerm_resource_group.main.location

  vm_size                      = "Standard_D2s_v3"
  number_of_hosts              = 3
  host_pool_type               = "Pooled"
  host_pool_load_balancer_type = "BreadthFirst"

  avd_admins_object_ids = [data.azuread_group.admins.object_id]
  avd_users_object_ids  = [data.azuread_group.users.object_id]

  workspace_friendly_name = "Groups assigned shared hosts"

  subnet_id = azurerm_subnet.main.id
}
```

### Personal hosts
This is an example on how to deploy personal hosts. The hosts will be assigned when a user first logs in and the assignments will last unitl manually unassigned. Keep in mind that the users will still have access to other hosts through RDP if the network permits it. [Full example here](./examples/user-assigned-personal/).
```terraform
module "avd" {
  source  = "decensas/azure-virtual-desktop/azurerm"
  version = "0.1.2"

  system_name         = "avd"
  resource_group_name = azurerm_resource_group.main.name
  data_location       = azurerm_resource_group.main.location
  host_location       = azurerm_resource_group.main.location

  vm_size             = "Standard_D2s_v3"
  number_of_hosts     = 3
  host_pool_type      = "Personal"
  start_vm_on_connect = true

  avd_users_upns  = ["user1@domain.com", "user2@domain.com"]
  avd_admins_upns = ["admin@domain.com"]

  workspace_friendly_name = "User assigned personal hosts"

  subnet_id = azurerm_subnet.main.id
}
```

### Availability set
This example shows how to make the module deploy an availability set for the VMs. [Full example here](./examples/availability-set/main.tf).
```terraform
module "avd" {
  source  = "decensas/azure-virtual-desktop/azurerm"
  version = "0.1.2"

  system_name         = "avd"
  resource_group_name = azurerm_resource_group.main.name
  data_location       = azurerm_resource_group.main.location
  host_location       = azurerm_resource_group.main.location

  use_availability_set                  = true
  availability_number_of_fault_domains  = 3
  availability_number_of_update_domains = 20

  vm_size         = "Standard_D2s_v3"
  number_of_hosts = 3
  host_pool_type  = "Personal"

  avd_users_upns  = ["user1@domain.com", "user2@domain.com"]
  avd_admins_upns = ["admin@domain.com"]

  workspace_friendly_name = "Availability set"

  subnet_id = azurerm_subnet.main.id
}
```

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
| [azurerm_availability_set.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [azurerm_network_interface.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_role_assignment.admins](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.appgroup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.start_on_connect](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
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
| [azuread_service_principal.avd](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_users.admins](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users) | data source |
| [azuread_users.users](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users) | data source |
| [azurerm_subscription.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_joined_allow_access_from_nonjoined"></a> [aad\_joined\_allow\_access\_from\_nonjoined](#input\_aad\_joined\_allow\_access\_from\_nonjoined) | Only applicable if using Azure AD authentication: adds a custom RDP property that allows access to the hosts from non-joined clients. | `bool` | `true` | no |
| <a name="input_availability_number_of_fault_domains"></a> [availability\_number\_of\_fault\_domains](#input\_availability\_number\_of\_fault\_domains) | The number of fault domains to configure for the availability set. The number of supported domains varies from region to region. [See a list here](https://github.com/MicrosoftDocs/azure-docs/blob/main/includes/managed-disks-common-fault-domain-region-list.md). Requires `var.use_availability_sets` to be true. | `number` | `2` | no |
| <a name="input_availability_number_of_update_domains"></a> [availability\_number\_of\_update\_domains](#input\_availability\_number\_of\_update\_domains) | The number of update domains to configure for the availability set. Must be between 1 and 20. Requires `var.use_availability_set` to be true. | `number` | `5` | no |
| <a name="input_avd_admins_object_ids"></a> [avd\_admins\_object\_ids](#input\_avd\_admins\_object\_ids) | Set of object IDs of the identites (Azure AD users or groups) who will be authorized to log into the VMs as local administrator. Useful if the identity running Terraform doesn't have Directory.Read-access to Azure AD or if you wish to assign a group, otherwise use var.avd\_admins\_upns. | `set(string)` | `[]` | no |
| <a name="input_avd_admins_upns"></a> [avd\_admins\_upns](#input\_avd\_admins\_upns) | Set of user principal names for the users who will be authorized to log into the VMs as local administrator. | `set(string)` | `[]` | no |
| <a name="input_avd_users_object_ids"></a> [avd\_users\_object\_ids](#input\_avd\_users\_object\_ids) | Set of object IDs of the identites (Azure AD users or groups) who will be authorized to log into the VMs as regular users. Useful if the identity running Terraform doesn't have Directory.Read-access to Azure AD or if you wish to assign a group, otherwise use var.avd\_users\_upns. | `set(string)` | `[]` | no |
| <a name="input_avd_users_upns"></a> [avd\_users\_upns](#input\_avd\_users\_upns) | Set of user principal names for the users who will be authorized to log into the VMs as regular users. | `set(string)` | `[]` | no |
| <a name="input_custom_rdp_properties"></a> [custom\_rdp\_properties](#input\_custom\_rdp\_properties) | Set of strings that will be added as custom RDP properties. E.g.: ["audiocapturemode:i:1", "audiomode:i:0"] | `set(string)` | `[]` | no |
| <a name="input_data_location"></a> [data\_location](#input\_data\_location) | The location to which metadata-resources will be deployed. This includes the host-pool, application group and workspace. Location of the virtual machines is defined by var.host\_location. See [Data locations for Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/data-locations). | `string` | n/a | yes |
| <a name="input_desktop_application_group_name_override"></a> [desktop\_application\_group\_name\_override](#input\_desktop\_application\_group\_name\_override) | Overrides the default name for the deskop application group. Defaults to `<var.system_name>-appgroup`. | `string` | `""` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | Should accelerated networking be enabled on the hosts? Only supported by [certain vm sizes](https://learn.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview#supported-vm-instances). | `bool` | `false` | no |
| <a name="input_host_location"></a> [host\_location](#input\_host\_location) | The location to which the hosts (VMs) will be deployed. | `string` | n/a | yes |
| <a name="input_host_pool_load_balancer_type"></a> [host\_pool\_load\_balancer\_type](#input\_host\_pool\_load\_balancer\_type) | Only applicable if var.host\_pool\_type is Pooled: Load balancing method used for new users sessions across the availiable hosts. Valid options are: `BreadthFirst`, `DepthFirst`. | `string` | `"BreadthFirst"` | no |
| <a name="input_host_pool_name_override"></a> [host\_pool\_name\_override](#input\_host\_pool\_name\_override) | Overrides the default name for the host pool. Defaults to `<var.system_name>-hostpool`. | `string` | `""` | no |
| <a name="input_host_pool_type"></a> [host\_pool\_type](#input\_host\_pool\_type) | The type of the host pool. Valid options are `Personal` or `Pooled` | `string` | n/a | yes |
| <a name="input_host_source_image_reference"></a> [host\_source\_image\_reference](#input\_host\_source\_image\_reference) | The reference to the operating system that will be used in the hosts. You can find this with [az cli](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage) or [PowerShell](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage). This should most likely be a variant of Windows 10/11 enterprise multi session-edition or Windows Server. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | <pre>{<br>  "offer": "windows-11",<br>  "publisher": "microsoftwindowsdesktop",<br>  "sku": "win11-21h2-avd",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies a type of on-premises license to be used with the session hosts. Sometimes referred to as Azure Hybrid Benefit. You must have a license with mutli-tenant hosting rights ([Windows Server](https://learn.microsoft.com/en-us/windows-server/get-started/azure-hybrid-benefit) or [Windows 10/11](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment)). Possible values are `None`, `Windows_Client` and `Windows_Server`. | `string` | `"None"` | no |
| <a name="input_local_admin_password"></a> [local\_admin\_password](#input\_local\_admin\_password) | The password of the local admin account on the hosts. Defaults to generating a random password per host. This will be saved in state. | `string` | `""` | no |
| <a name="input_local_admin_username"></a> [local\_admin\_username](#input\_local\_admin\_username) | The username of the local admin account on the hosts. | `string` | `"azureuser"` | no |
| <a name="input_network_interface_name_format"></a> [network\_interface\_name\_format](#input\_network\_interface\_name\_format) | The format of the NIC names. The string is var.system\_name. The number is the NIC number. See [format-function](https://www.terraform.io/language/functions/format). | `string` | `"%s-nic%02d"` | no |
| <a name="input_number_of_hosts"></a> [number\_of\_hosts](#input\_number\_of\_hosts) | The number of hosts that will be deployed. | `number` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to deploy the AVD-resources. | `string` | n/a | yes |
| <a name="input_start_vm_on_connect"></a> [start\_vm\_on\_connect](#input\_start\_vm\_on\_connect) | Will enable automatic start of hosts on connection when required. Separate automation is required to stop and deallocate hosts. | `bool` | `false` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to where the hosts will be deployed. Must be in the same region as var.host\_location. | `string` | n/a | yes |
| <a name="input_system_name"></a> [system\_name](#input\_system\_name) | The main name of the system. Will be used as a part of naming for multiple resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to all deployed resources. | `map(string)` | `{}` | no |
| <a name="input_use_availability_set"></a> [use\_availability\_set](#input\_use\_availability\_set) | Should the VMs be deployed to an availability set? | `bool` | `false` | no |
| <a name="input_virtual_machine_name_format"></a> [virtual\_machine\_name\_format](#input\_virtual\_machine\_name\_format) | The format of the VM names. The string is var.system\_name. The number is the VM number. See [format-function](https://www.terraform.io/language/functions/format). | `string` | `"%s-vm%02d"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the hosts. E.g. `Standard_D2s_v3`. See [Microsoft Docs: VM sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes). | `string` | n/a | yes |
| <a name="input_workspace_friendly_name"></a> [workspace\_friendly\_name](#input\_workspace\_friendly\_name) | Gives the ability to give a user-facing name to the AVD workspace. Will by default appear to the user as `<var.system_name>-workspace`. | `string` | `""` | no |
| <a name="input_workspace_name_override"></a> [workspace\_name\_override](#input\_workspace\_name\_override) | Overrides the default name for the workspace. Defaults to `<var.system_name>-workspace`. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_interfaces"></a> [network\_interfaces](#output\_network\_interfaces) | An array of the NIC-objects created by this module. |
| <a name="output_virtual_machines"></a> [virtual\_machines](#output\_virtual\_machines) | An array of the VM-objects created by this module. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## :information_source: Users with MFA required
>If you're assigning users with MFA required, do note that they need to connect from a client that is joined to the same Azure AD and using Windows 10 2004 or later using either the Windows Client or Microsoft Edge. If this isn't a possibility, you must exclude the [Windows VM Login application from MFA](https://docs.microsoft.com/en-us/azure/virtual-desktop/set-up-mfa) using Azure AD Conditional Access. If set up correctly, MFA will still be required to use the Azure Virtual Desktop application.

## :warning: Security note
>Be aware that the module sets role assignments on the resource group level. Meaning that *admins and users defined in the input variables will be given the same access to other VMs in the same resource group*.

## Feature: Start VM on connect
>You can enable the [Start VM on Connect](https://learn.microsoft.com/en-us/azure/virtual-desktop/start-virtual-machine-connect)-feature by setting `var.start_vm_on_connect`. This will allocate deallocated VMs on user sign-in when required. It will not stop and/or deallocate running VMs. Separate automation can be set up for deallocation of unused hosts.

## Roadmap
 - [X] Azure AD authentication to hosts
 - [ ] [Autoscale plans](https://github.com/decensas/terraform-azurerm-azure-virtual-desktop/issues/9)
 - [ ] [Personal user profile roaming using fslogix](https://github.com/decensas/terraform-azurerm-azure-virtual-desktop/issues/8)
 - [X] [Infrastructure redundancy](https://github.com/decensas/terraform-azurerm-azure-virtual-desktop/issues/7)
 - [ ] [Add flags for default RDP properties](https://github.com/decensas/terraform-azurerm-azure-virtual-desktop/issues/6)
