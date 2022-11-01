resource "azurerm_resource_group" "avsftp_rg" {
  name     = "${random_string.name_prefix.result}-${var.resource_group_name}"
  location = var.location
}