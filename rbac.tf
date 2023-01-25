data "azuread_users" "users" {
  user_principal_names = var.avd_users_upns
}

data "azuread_users" "admins" {
  user_principal_names = var.avd_admins_upns
}

# This is the service principal for the Microsoft-managed AVD application
# It will vary depending on when your tenant first registered for AVD,
# But its application ID will always be the one below, see:
# https://learn.microsoft.com/en-us/azure/virtual-desktop/start-virtual-machine-connect?tabs=azure-portal
data "azuread_service_principal" "avd" {
  application_id = "9cdead84-a844-4324-93f2-b2e6bb768d07"
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

resource "azurerm_role_assignment" "start_on_connect" {
  count                = var.start_vm_on_connect == true ? 1 : 0
  role_definition_name = "Desktop Virtualization Power On Contributor"
  principal_id         = data.azuread_service_principal.avd.object_id
  scope                = local.resource_group_id
}
