############################################################
# NSG 
############################################################

resource "azurerm_network_security_group" "avsftp_nsg" {
  name                = "${random_string.name_prefix.result}-${var.avsftp_nsg_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.avsftp_rg.name

  depends_on = [azurerm_resource_group.avsftp_rg]
}

############################################################
# NSG rules
############################################################

resource "azurerm_network_security_rule" "avsftp_nsg_rules" {
  for_each                     = local.avsftp_nsg_rules
  name                         = each.value.name
  direction                    = each.value.direction
  access                       = each.value.access
  priority                     = each.value.priority
  protocol                     = each.value.protocol
  source_port_range            = each.value.source_port_range != "" ? each.value.source_port_range : null
  destination_port_range       = each.value.destination_port_range != "" ? each.value.destination_port_range : null
  source_port_ranges           = each.value.source_port_ranges != [""] ? each.value.source_port_ranges : null
  destination_port_ranges      = each.value.destination_port_ranges != [""] ? each.value.destination_port_ranges : null
  source_address_prefix        = each.value.source_address_prefix != "" ? each.value.source_address_prefix : null
  destination_address_prefix   = each.value.destination_address_prefix != "" ? each.value.destination_address_prefix : null
  source_address_prefixes      = each.value.source_address_prefixes != [""] ? each.value.source_address_prefixes : null
  destination_address_prefixes = each.value.destination_address_prefixes != [""] ? each.value.destination_address_prefixes : null
  resource_group_name          = azurerm_resource_group.avsftp_rg.name
  network_security_group_name  = azurerm_network_security_group.avsftp_nsg.name

  depends_on = [azurerm_network_security_group.avsftp_nsg, azurerm_resource_group.avsftp_rg]
}

############################################################
# NSG associations
############################################################

resource "azurerm_subnet_network_security_group_association" "avsftp_function_subnet_nsg_associations" {
  subnet_id                 = azurerm_subnet.avsftp_vnet_function_subnet.id
  network_security_group_id = azurerm_network_security_group.avsftp_nsg.id

  depends_on = [azurerm_virtual_network.avsftp_vnet, azurerm_network_security_group.avsftp_nsg]
}

resource "azurerm_subnet_network_security_group_association" "avsftp_vm_subnet_nsg_associations" {
  subnet_id                 = azurerm_subnet.avsftp_vnet_vm_subnet.id
  network_security_group_id = azurerm_network_security_group.avsftp_nsg.id

  depends_on = [azurerm_virtual_network.avsftp_vnet, azurerm_network_security_group.avsftp_nsg]
}