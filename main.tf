data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_resource_group" "triggererror" {
