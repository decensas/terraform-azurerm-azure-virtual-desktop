locals {
  host_pool_name                 = var.host_pool_name_override == "" ? "${var.system_name}-hostpool" : var.host_pool_name_override
  workspace_name                 = var.workspace_name_override == "" ? "${var.system_name}-workspace" : var.workspace_name_override
  desktop_application_group_name = var.desktop_application_group_name_override == "" ? "${var.system_name}-appgroup" : var.desktop_application_group_name_override

  host_pool_load_balancer_type = var.host_pool_type == "Personal" ? "Persistent" : var.host_pool_load_balancer_type

  custom_rdp_properties = var.aad_joined_allow_access_from_nonjoined ? "targetisaadjoined:i:1" : ""
}
