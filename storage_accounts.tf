resource "azurerm_storage_account" "av_storage_account" {
  name                     = "${random_string.name_prefix.result}${var.av_storage_account_name}"
  resource_group_name      = azurerm_resource_group.avsftp_rg.name
  location                 = azurerm_resource_group.avsftp_rg.location
  account_kind             = var.av_storage_account_kind
  account_tier             = var.av_storage_account_tier
  account_replication_type = var.av_storage_account_replication_type

  depends_on = [azurerm_resource_group.avsftp_rg]
}

resource "azurerm_storage_account" "sftp_storage_account" {
  name                     = "${random_string.name_prefix.result}${var.sftp_storage_account_name}"
  resource_group_name      = azurerm_resource_group.avsftp_rg.name
  location                 = azurerm_resource_group.avsftp_rg.location
  account_kind             = var.sftp_storage_account_kind
  account_tier             = var.sftp_storage_account_tier
  account_replication_type = var.sftp_storage_account_replication_type

  is_hns_enabled = true

  # waiting to be supported so in the meantime manually enable SFTP and add local users
  #is_local_user_enabled = true
  #is_sftp_enabled = true

  depends_on = [azurerm_resource_group.avsftp_rg]
}

resource "azurerm_storage_container" "new-files" {
  name                  = var.sftp_storage_accounts_new_files_container_name
  storage_account_name  = azurerm_storage_account.sftp_storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "quarantine-files" {
  name                  = var.sftp_storage_accounts_quarantine_files_container_name
  storage_account_name  = azurerm_storage_account.sftp_storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "clean-files" {
  name                  = var.sftp_storage_accounts_clean_files_container_name
  storage_account_name  = azurerm_storage_account.sftp_storage_account.name
  container_access_type = "private"
}