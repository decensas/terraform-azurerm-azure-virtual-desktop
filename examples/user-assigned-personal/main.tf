provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "d-avd-user-assigned-personal"
  location = "westeurope"
}

resource "azurerm_virtual_network" "main" {
  name                = "d-avd-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  address_space = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "main" {
  name                 = "default"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_virtual_network.main.resource_group_name

  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name                = "d-avd-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

module "avd" {
  source  = "decensas/azure-virtual-desktop/azurerm"
  version = "0.1.2"

  system_name         = "avd"
  resource_group_name = azurerm_resource_group.main.name
  data_location       = azurerm_resource_group.main.location
  host_location       = azurerm_resource_group.main.location

  vm_size             = "Standard_D2s_v3"
  number_of_hosts     = 3
  host_pool_type      = "Personal"
  start_vm_on_connect = true

  avd_users_upns  = ["user1@domain.com", "user2@domain.com"]
  avd_admins_upns = ["admin@domain.com"]

  workspace_friendly_name = "User assigned personal hosts"

  subnet_id = azurerm_subnet.main.id
}
