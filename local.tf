locals {
  host_pool_name = var.host_pool_name_override == "" ? "${var.system_name}-hostpool" : var.host_pool_name_override

  custom_rdp_properties = var.aad_joined_allow_access_from_nonjoined ? "targetisaadjoined:i:1" : ""
}