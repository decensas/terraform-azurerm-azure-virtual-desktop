variable "system_name" {
  type        = string
  description = "The main name of the system. Will be used as a part of naming for multiple resources."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to deploy the AVD-resources."
}
