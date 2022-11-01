locals {
  avsftp_nsg_rules = {
    function_vm_inbound = {
      name                         = "Function-VM-Communication-Rule-in"
      priority                     = 1000
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_port_ranges           = [""]
      destination_port_range       = "443"
      destination_port_ranges      = [""]
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = [""]
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = [""]
    }

    function_vm_outbound = {
      name                         = "Function-VM-Communication-Rule-out"
      priority                     = 1000
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_port_ranges           = [""]
      destination_port_range       = "443"
      destination_port_ranges      = [""]
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = [""]
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = [""]
    }
  }
}
