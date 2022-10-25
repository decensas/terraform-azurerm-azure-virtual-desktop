resource "azurerm_availability_set" "main" {
  count               = var.use_availability_set == true ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.host_location
  name                = "${var.system_name}-availset"
}

resource "azurerm_windows_virtual_machine" "main" {
  count               = var.number_of_hosts
  name                = format(var.virtual_machine_name_format, var.system_name, count.index)
  location            = var.host_location
  resource_group_name = var.resource_group_name

  network_interface_ids = [azurerm_network_interface.main[count.index].id]
  size                  = var.vm_size
  admin_username        = var.local_admin_username
  admin_password        = local.local_admin_password[count.index]

  availability_set_id = one(azurerm_availability_set.main[*].id)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  license_type = var.license_type
  source_image_reference {
    publisher = var.host_source_image_reference.publisher
    offer     = var.host_source_image_reference.offer
    sku       = var.host_source_image_reference.sku
    version   = var.host_source_image_reference.version
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {}

  lifecycle {
    replace_triggered_by = [
      azurerm_virtual_desktop_host_pool.main.id
    ]
  }

  tags = var.tags
}

resource "azurerm_network_interface" "main" {
  count               = var.number_of_hosts
  name                = format(var.network_interface_name_format, var.system_name, count.index)
  location            = var.host_location
  resource_group_name = var.resource_group_name

  enable_accelerated_networking = var.enable_accelerated_networking
  ip_configuration {
    name                          = "default"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "aad_join" {
  count = var.number_of_hosts

  name               = "AADLoginForWindows"
  virtual_machine_id = azurerm_windows_virtual_machine.main[count.index].id

  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "hostpool_join" {
  count = var.number_of_hosts

  name               = "DSC"
  virtual_machine_id = azurerm_windows_virtual_machine.main[count.index].id

  depends_on = [
    azurerm_virtual_machine_extension.aad_join
  ]

  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    modulesUrl            = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_08-10-2022.zip"
    configurationFunction = "Configuration.ps1\\AddSessionHost"
    properties = {
      hostPoolName          = azurerm_virtual_desktop_host_pool.main.name
      registrationInfoToken = azurerm_virtual_desktop_host_pool_registration_info.main.token
      aadJoin               = true
      aadJoinPreview        = false
    }
  })

  lifecycle {
    ignore_changes = [settings]
    replace_triggered_by = [
      azurerm_virtual_desktop_host_pool.main.id
    ]
  }

  tags = var.tags
}
