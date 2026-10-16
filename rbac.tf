data "azuread_users" "users" {
  user_principal_names = var.avd_users_upns
}

data "azuread_users" "admins" {
  user_principal_names = var.avd_admins_upns
}

# This is the client ID for the Microsoft-managed AVD application.
# See:
# https://learn.microsoft.com/en-us/azure/virtual-desktop/start-virtual-machine-connect?tabs=azure-portal
data "azuread_service_principal" "avd" {
  client_id = "9cdead84-a844-4324-93f2-b2e6bb768d07"
}

locals {
  avd_user_vm_role_assignments = {
    for assignment in setproduct(local.avd_users_object_ids, azurerm_windows_virtual_machine.main) :
    "${assignment[1].name}-${assignment[0]}" => {
      vm_id        = assignment[1].id
      principal_id = assignment[0]
    }
  }

  avd_admin_vm_role_assignments = {
    for assignment in setproduct(local.avd_admins_object_ids, azurerm_windows_virtual_machine.main) :
    "${assignment[1].name}-${assignment[0]}" => {
      vm_id        = assignment[1].id
      principal_id = assignment[0]
    }
  }
}

resource "azurerm_role_assignment" "users" {
  for_each             = local.avd_user_vm_role_assignments
  scope                = each.value.vm_id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "admins" {
  for_each             = local.avd_admin_vm_role_assignments
  scope                = each.value.vm_id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "appgroup" {
  for_each             = setunion(local.avd_users_object_ids, local.avd_admins_object_ids)
  scope                = azurerm_virtual_desktop_application_group.main.id
  role_definition_name = "Desktop Virtualization User"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "start_on_connect" {
  for_each             = var.start_vm_on_connect ? { for index, vm in azurerm_windows_virtual_machine.main : tostring(index) => vm.id } : {}
  role_definition_name = "Desktop Virtualization Power On Contributor"
  principal_id         = data.azuread_service_principal.avd.object_id
  scope                = each.value
}
