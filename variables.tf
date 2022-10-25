variable "system_name" {
  type        = string
  description = "The main name of the system. Will be used as a part of naming for multiple resources."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to deploy the AVD-resources."
}

variable "data_location" {
  type        = string
  description = "The location to which metadata-resources will be deployed. This includes the host-pool, application group and workspace. Location of the virtual machines is defined by var.host_location. See [Data locations for Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/data-locations)."
}

variable "host_location" {
  type        = string
  description = "The location to which the hosts (VMs) will be deployed."
}

variable "vm_size" {
  type        = string
  description = "The size of the hosts. E.g. `Standard_D2s_v3`. See [Microsoft Docs: VM sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes)."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to where the hosts will be deployed. Must be in the same region as var.host_location."
}

variable "host_source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "The reference to the operating system that will be used in the hosts. You can find this with [az cli](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage) or [PowerShell](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage). This should most likely be a variant of Windows 10/11 enterprise multi session-edition or Windows Server."

  default = {
    offer     = "windows-11"
    publisher = "microsoftwindowsdesktop"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }
}

variable "local_admin_username" {
  type        = string
  description = "The username of the local admin account on the hosts."
  default     = "azureuser"
}

variable "local_admin_password" {
  type        = string
  description = "The password of the local admin account on the hosts. Defaults to generating a random password per host. This will be saved in state."
  default     = ""
  sensitive   = true
}

variable "license_type" {
  type        = string
  description = "Specifies a type of on-premises license to be used with the session hosts. Sometimes referred to as Azure Hybrid Benefit. You must have a license with mutli-tenant hosting rights ([Windows Server](https://learn.microsoft.com/en-us/windows-server/get-started/azure-hybrid-benefit) or [Windows 10/11](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment)). Possible values are `None`, `Windows_Client` and `Windows_Server`."
  default     = "None"
  validation {
    condition     = contains(["None", "Windows_Client", "Windows_Server"], var.license_type)
    error_message = "The value of var.license type must be one of: None, Windows_Client, Windows_Server"
  }
}

variable "number_of_hosts" {
  type        = number
  description = "The number of hosts that will be deployed."
}

variable "start_vm_on_connect" {
  type        = bool
  description = "Will enable automatic start of hosts on connection when required. Separate automation is required to stop and deallocate hosts."
  default     = false
}

variable "host_pool_type" {
  type        = string
  description = "The type of the host pool. Valid options are `Personal` or `Pooled`"
  validation {
    condition     = contains(["Personal", "Pooled"], var.host_pool_type)
    error_message = "The value of var.host_pool_type must be one of: Personal, Pooled."
  }
}

variable "host_pool_load_balancer_type" {
  type        = string
  description = "Only applicable if var.host_pool_type is Pooled: Load balancing method used for new users sessions across the availiable hosts. Valid options are: `BreadthFirst`, `DepthFirst`."
  validation {
    condition     = contains(["BreadthFirst", "DepthFirst"], var.host_pool_load_balancer_type)
    error_message = "The value of var.host_pool_load_balancer_type must be one of: Persistent, BreadthFirst."
  }
  default = "BreadthFirst"
}

variable "host_pool_name_override" {
  type        = string
  description = "Overrides the default name for the host pool. Defaults to `<var.system_name>-hostpool`."
  default     = ""
}

variable "workspace_name_override" {
  type        = string
  description = "Overrides the default name for the workspace. Defaults to `<var.system_name>-workspace`."
  default     = ""
}

variable "desktop_application_group_name_override" {
  type        = string
  description = "Overrides the default name for the deskop application group. Defaults to `<var.system_name>-appgroup`."
  default     = ""
}

variable "workspace_friendly_name" {
  type        = string
  description = "Gives the ability to give a user-facing name to the AVD workspace. Will by default appear to the user as `<var.system_name>-workspace`."
  default     = ""
}

variable "network_interface_name_format" {
  type        = string
  description = "The format of the NIC names. The string is var.system_name. The number is the NIC number. See [format-function](https://www.terraform.io/language/functions/format)."
  default     = "%s-nic%02d"
}

variable "virtual_machine_name_format" {
  type        = string
  description = "The format of the VM names. The string is var.system_name. The number is the VM number. See [format-function](https://www.terraform.io/language/functions/format)."
  default     = "%s-vm%02d"
}

variable "custom_rdp_properties" {
  type        = set(string)
  description = "Set of strings that will be added as custom RDP properties. E.g.: [\"audiocapturemode:i:1\", \"audiomode:i:0\"]"
  default     = []
}

variable "aad_joined_allow_access_from_nonjoined" {
  type        = bool
  description = "Only applicable if using Azure AD authentication: adds a custom RDP property that allows access to the hosts from non-joined clients."
  default     = true
}

variable "avd_users_upns" {
  type        = set(string)
  description = "Set of user principal names for the users who will be authorized to log into the VMs as regular users."
  default     = []
}

variable "avd_admins_upns" {
  type        = set(string)
  description = "Set of user principal names for the users who will be authorized to log into the VMs as local administrator."
  default     = []
}

variable "avd_users_object_ids" {
  type        = set(string)
  description = "Set of object IDs of the identites (Azure AD users or groups) who will be authorized to log into the VMs as regular users. Useful if the identity running Terraform doesn't have Directory.Read-access to Azure AD or if you wish to assign a group, otherwise use var.avd_users_upns."
  default     = []
}

variable "avd_admins_object_ids" {
  type        = set(string)
  description = "Set of object IDs of the identites (Azure AD users or groups) who will be authorized to log into the VMs as local administrator. Useful if the identity running Terraform doesn't have Directory.Read-access to Azure AD or if you wish to assign a group, otherwise use var.avd_admins_upns."
  default     = []
}

variable "use_availability_set" {
  type        = bool
  description = "Should the VMs be deployed to an availability set?"
  default     = false
}

variable "availability_number_of_fault_domains" {
  type        = number
  description = "The number of fault domains to configure for the availability set. The number of supported domains varies from region to region. [See a list here](https://github.com/MicrosoftDocs/azure-docs/blob/main/includes/managed-disks-common-fault-domain-region-list.md). Requires `var.use_availability_sets` to be true."
  default     = 2
}

variable "availability_number_of_update_domains" {
  type        = number
  description = "The number of update domains to configure for the availability set. Must be between 1 and 20. Requires `var.use_availability_set` to be true."
  default     = 5
  validation {
    condition = (
      var.availability_number_of_update_domains >= 1 &&
      var.availability_number_of_update_domains <= 20
    )
    error_message = "The value of var.availability_number_of_update_domains must be between 1 and 20."
  }
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "Should accelerated networking be enabled on the hosts? Only supported by [certain vm sizes](https://learn.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview#supported-vm-instances)."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags that will be applied to all deployed resources."
  default     = {}
}
