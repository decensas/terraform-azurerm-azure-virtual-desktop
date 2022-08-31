data "azurerm_subscription" "main" {}

resource "random_password" "main" {
  count       = var.number_of_hosts
  length      = 30
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}
