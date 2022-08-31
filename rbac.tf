data "azuread_users" "users" {
  user_principal_names = var.avd_users_upns
}

data "azuread_users" "admins" {
  user_principal_names = var.avd_admins_upns
}

resource "azurerm_role_assignment" "users" {
  for_each             = local.avd_users_object_ids
  scope                = local.resource_group_id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "admins" {
  for_each             = local.avd_admins_object_ids
  scope                = local.resource_group_id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "appgroup" {
  for_each             = setunion(local.avd_users_object_ids, local.avd_admins_object_ids)
  scope                = azurerm_virtual_desktop_application_group.main.id
  role_definition_name = "Desktop Virtualization User"
  principal_id         = each.value
}
