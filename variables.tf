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
  description = "The size of the hosts. E.g. `Standard_D2s_v3`."
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
  description = "The password of the local admin account on the hosts. Defaults to a randomly generated password. This will be saved in state."
  default     = ""
  sensitive   = true
}

variable "number_of_hosts" {
  type        = number
  description = "The number of hosts that will be deployed."
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

variable "tags" {
  type        = map(string)
  description = "Tags that will be applied to all deployed resources."
  default     = {}
}
