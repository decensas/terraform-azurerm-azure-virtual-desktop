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
  description = "Overrides the default name for the deskop_application_group. Defaults to `<var.system_name>-appgroup`."
  default     = ""
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