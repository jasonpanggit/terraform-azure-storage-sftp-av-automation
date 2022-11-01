resource "azurerm_network_interface" "av_vm_network_interface" {
  name                = "${random_string.name_prefix.result}-${var.av_vm_network_interface_name}"
  resource_group_name = azurerm_resource_group.avsftp_rg.name
  location            = azurerm_resource_group.avsftp_rg.location

  ip_configuration {
    name                          = var.av_vm_ip_config_name
    subnet_id                     = azurerm_subnet.avsftp_vnet_vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_resource_group.avsftp_rg
  ]
}

resource "azurerm_windows_virtual_machine" "av_vm" {
  name                = "${random_string.name_prefix.result}-${var.av_vm_name}"
  resource_group_name = azurerm_resource_group.avsftp_rg.name
  location            = azurerm_resource_group.avsftp_rg.location
  size                = var.av_vm_size
  computer_name       = var.av_vm_computer_name
  admin_username      = var.av_vm_username
  admin_password      = var.av_vm_password
  network_interface_ids = [
    azurerm_network_interface.av_vm_network_interface.id,
  ]

  os_disk {
    name                 = var.av_vm_osdisk_name
    caching              = var.av_vm_osdisk_caching
    storage_account_type = var.av_vm_osdisk_storage_account_type
    disk_size_gb         = var.av_vm_osdisk_size
  }

  source_image_reference {
    publisher = var.av_vm_source_img_ref_publisher
    offer     = var.av_vm_source_img_ref_offer
    sku       = var.av_vm_source_img_ref_sku
    version   = var.av_vm_source_img_ref_version
  }

  depends_on = [
    azurerm_resource_group.avsftp_rg,
    azurerm_network_interface.av_vm_network_interface
  ]
}

resource "azurerm_virtual_machine_extension" "av_vm_extension" {
  name                 = "${azurerm_windows_virtual_machine.av_vm.name}-script"
  virtual_machine_id   = azurerm_windows_virtual_machine.av_vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "fileUris": [
          "${var.vm_init_script_url}"
        ],
        "commandToExecute": "powershell.exe -ExecutionPolicy Bypass -File VMInit.ps1 \"${var.scan_http_server_url}\""
    }
SETTINGS
  depends_on = [
    azurerm_windows_virtual_machine.av_vm
  ]
}