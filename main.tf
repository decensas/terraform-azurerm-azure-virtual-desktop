resource "azurerm_virtual_desktop_host_pool" "main" {
  location            = var.data_location
  resource_group_name = var.resource_group_name

  name                  = local.host_pool_name
  custom_rdp_properties = local.custom_rdp_properties
  type                  = var.host_pool_type
  load_balancer_type    = local.host_pool_load_balancer_type

  tags = var.tags
}

resource "azurerm_virtual_desktop_workspace" "main" {
  name                = local.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.data_location

  tags = var.tags
}

resource "azurerm_virtual_desktop_application_group" "main" {
  name                = local.desktop_application_group_name
  resource_group_name = var.resource_group_name
  location            = var.data_location
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.main.id

  tags = var.tags
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "main" {
  workspace_id         = azurerm_virtual_desktop_workspace.main.id
  application_group_id = azurerm_virtual_desktop_application_group.main.id
}
