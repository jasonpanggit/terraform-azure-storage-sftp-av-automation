resource "azurerm_virtual_network" "avsftp_vnet" {
  name                = "${random_string.name_prefix.result}-${var.avsftp_vnet_name}"
  address_space       = var.avsftp_vnet_address_space
  resource_group_name = azurerm_resource_group.avsftp_rg.name
  location            = azurerm_resource_group.avsftp_rg.location

  depends_on = [azurerm_resource_group.avsftp_rg]
}

resource "azurerm_subnet" "avsftp_vnet_function_subnet" {
  name                 = "${random_string.name_prefix.result}-${var.avsftp_vnet_function_subnet_name}"
  resource_group_name  = azurerm_resource_group.avsftp_rg.name
  virtual_network_name = azurerm_virtual_network.avsftp_vnet.name
  address_prefixes     = var.avsftp_vnet_function_subnet_address_prefixes

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  depends_on = [azurerm_resource_group.avsftp_rg, azurerm_virtual_network.avsftp_vnet]
}

resource "azurerm_subnet" "avsftp_vnet_vm_subnet" {
  name                 = "${random_string.name_prefix.result}-${var.avsftp_vnet_vm_subnet_name}"
  resource_group_name  = azurerm_resource_group.avsftp_rg.name
  virtual_network_name = azurerm_virtual_network.avsftp_vnet.name
  address_prefixes     = var.avsftp_vnet_vm_subnet_address_prefixes

  depends_on = [azurerm_resource_group.avsftp_rg, azurerm_virtual_network.avsftp_vnet]
}

resource "azurerm_subnet" "avsftp_vnet_sftp_subnet" {
  name                 = "${random_string.name_prefix.result}-${var.avsftp_vnet_sftp_subnet_name}"
  resource_group_name  = azurerm_resource_group.avsftp_rg.name
  virtual_network_name = azurerm_virtual_network.avsftp_vnet.name
  address_prefixes     = var.avsftp_vnet_sftp_subnet_address_prefixes

  depends_on = [azurerm_resource_group.avsftp_rg, azurerm_virtual_network.avsftp_vnet]
}