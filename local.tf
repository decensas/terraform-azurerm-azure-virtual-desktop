locals {
  resource_group_id = "/subscriptions/${data.azurerm_subscription.main.subscription_id}/resourceGroups/${var.resource_group_name}"

  host_pool_name                 = var.host_pool_name_override == "" ? "${var.system_name}-hostpool" : var.host_pool_name_override
  workspace_name                 = var.workspace_name_override == "" ? "${var.system_name}-workspace" : var.workspace_name_override
  desktop_application_group_name = var.desktop_application_group_name_override == "" ? "${var.system_name}-appgroup" : var.desktop_application_group_name_override

  host_pool_load_balancer_type = var.host_pool_type == "Personal" ? "Persistent" : var.host_pool_load_balancer_type

  custom_rdp_properties = join(";",
    flatten([
      var.custom_rdp_properties,
      var.aad_joined_allow_access_from_nonjoined ? ["targetisaadjoined:i:1"] : [""]
    ])
  )

  local_admin_password = [
    for i in range(var.number_of_hosts) :
    var.local_admin_password == "" ? random_password.main[i].result : var.local_admin_password
  ]

  avd_users_object_ids = toset(flatten([
    var.avd_users_object_ids,
    data.azuread_users.users.object_ids
  ]))

  avd_admins_object_ids = toset(flatten([
    var.avd_admins_object_ids,
    data.azuread_users.admins.object_ids
  ]))
}
