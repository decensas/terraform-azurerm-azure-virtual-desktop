resource "azurerm_virtual_desktop_host_pool" "main" {
  location            = var.data_location
  resource_group_name = var.resource_group_name

  name                  = local.host_pool_name
  custom_rdp_properties = local.custom_rdp_properties != "" ? "${local.custom_rdp_properties};" : null
  type                  = var.host_pool_type
  load_balancer_type    = local.host_pool_load_balancer_type
  start_vm_on_connect   = var.start_hosts_on_connect

  personal_desktop_assignment_type = var.host_pool_type == "Personal" ? "Automatic" : null

  tags = var.tags
}

resource "azurerm_virtual_desktop_workspace" "main" {
  name                = local.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.data_location
  friendly_name       = var.workspace_friendly_name != "" ? var.workspace_friendly_name : null

  tags = var.tags
}

resource "azurerm_virtual_desktop_application_group" "main" {
  name                = local.desktop_application_group_name
  resource_group_name = var.resource_group_name
  location            = var.data_location
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.main.id

  lifecycle {
    replace_triggered_by = [
      azurerm_virtual_desktop_host_pool.main.id
    ]
  }

  tags = var.tags
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "main" {
  workspace_id         = azurerm_virtual_desktop_workspace.main.id
  application_group_id = azurerm_virtual_desktop_application_group.main.id
}

resource "time_static" "registration_token_expiration" {
  triggers = {
    for i, vm in azurerm_windows_virtual_machine.main : i => vm.virtual_machine_id # Recreate when a new VM is added or one is redeployed
  }
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "main" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.main.id
  expiration_date = timeadd(time_static.registration_token_expiration.rfc3339, "24h")
}
