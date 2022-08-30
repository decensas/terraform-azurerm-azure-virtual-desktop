resource "azurerm_virtual_desktop_host_pool" "main" {
  location            = var.data_location
  resource_group_name = var.resource_group_name

  name                  = local.host_pool_name
  custom_rdp_properties = local.custom_rdp_properties
  type                  = var.host_pool_type
  load_balancer_type    = local.host_pool_load_balancer_type
}