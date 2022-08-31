output "virtual_machines" {
  description = "An array of the VM-objects created by this module."
  value       = azurerm_windows_virtual_machine.main
}

output "network_interfaces" {
  description = "An array of the NIC-objects created by this module."
  value       = azurerm_network_interface.main
}
