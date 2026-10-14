locals {
  avd_session_host_registration_script = <<-POWERSHELL
    $ErrorActionPreference = "Stop"
    $registrationToken = '${azurerm_virtual_desktop_host_pool_registration_info.main.token}'
    $agentInstaller = Join-Path $env:TEMP "Microsoft.RDInfra.RDAgent.Installer-x64.msi"
    $bootLoaderInstaller = Join-Path $env:TEMP "Microsoft.RDInfra.RDAgentBootLoader.Installer-x64.msi"

    try {
      Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2310011" -OutFile $agentInstaller -UseBasicParsing
      Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2311028" -OutFile $bootLoaderInstaller -UseBasicParsing
      Unblock-File -Path $agentInstaller
      Unblock-File -Path $bootLoaderInstaller

      $agentInstall = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$agentInstaller`" /quiet REGISTRATIONTOKEN=$registrationToken" -Wait -PassThru
      if ($agentInstall.ExitCode -notin @(0, 3010)) {
        throw "Azure Virtual Desktop Agent installation failed with exit code $($agentInstall.ExitCode)."
      }

      $bootLoaderInstall = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$bootLoaderInstaller`" /quiet" -Wait -PassThru
      if ($bootLoaderInstall.ExitCode -notin @(0, 3010)) {
        throw "Azure Virtual Desktop Agent Boot Loader installation failed with exit code $($bootLoaderInstall.ExitCode)."
      }
    } catch {
      Write-Error $_
      exit 1
    }

    exit 0
  POWERSHELL
}

resource "azurerm_availability_set" "main" {
  count               = var.use_availability_set == true ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.host_location
  name                = "${var.system_name}-availset"

  platform_fault_domain_count  = var.availability_number_of_fault_domains
  platform_update_domain_count = var.availability_number_of_update_domains

  tags = var.tags
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

  accelerated_networking_enabled = var.enable_accelerated_networking
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

  name               = "RegisterSessionHost"
  virtual_machine_id = azurerm_windows_virtual_machine.main[count.index].id

  depends_on = [
    azurerm_virtual_machine_extension.aad_join
  ]

  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  protected_settings = jsonencode({
    commandToExecute = "powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -EncodedCommand ${textencodebase64(local.avd_session_host_registration_script, "UTF-16LE")}"
  })

  lifecycle {
    replace_triggered_by = [
      azurerm_virtual_desktop_host_pool.main.id
    ]
  }

  tags = var.tags
}
