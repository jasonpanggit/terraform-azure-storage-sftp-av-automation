data "azurerm_client_config" "current" {}

/*
resource "azurerm_key_vault" "avsftp_key_vault" {
  name                = "${random_string.name_prefix.result}-${var.avsftp_key_vault_name}"
  resource_group_name = azurerm_resource_group.avsftp_rg.name
  location            = azurerm_resource_group.avsftp_rg.location

  enabled_for_deployment          = false
  enabled_for_template_deployment = true
  enabled_for_disk_encryption     = false
  tenant_id                       = var.tenant_id
  
  sku_name = "standard"

  access_policy {
    # for terraform
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  depends_on = [
    azurerm_resource_group.avsftp_rg
  ]
}

resource "azurerm_user_assigned_identity" "av_function_app_user_assigned_identity" {
  name                = "${random_string.name_prefix.result}-av-functionapp-id"
  resource_group_name = azurerm_resource_group.avsftp_rg.name
  location            = azurerm_resource_group.avsftp_rg.location
}

# Access Policy
resource "azurerm_key_vault_access_policy" "avsftp_key_vault_function_app_access_policy" {
  key_vault_id = azurerm_key_vault.avsftp_key_vault.id
  tenant_id    = var.tenant_id
  object_id    = azurerm_function_app.av_function_app.identity.0.principal_id
  #object_id    = azurerm_user_assigned_identity.av_function_app_user_assigned_identity.principal_id

  secret_permissions = [
    "Get", 
  ]

  depends_on = [
    azurerm_function_app.av_function_app
  ]
}

resource "azurerm_key_vault_secret" "av_storage_account_key_vault_secret" {
  name         = "${random_string.name_prefix.result}-${var.av_storage_account_key_vault_secret_name}"
  value        = azurerm_storage_account.av_storage_account.primary_access_key
  key_vault_id = azurerm_key_vault.avsftp_key_vault.id

  depends_on = [
    azurerm_storage_account.av_storage_account,
    azurerm_key_vault.avsftp_key_vault
  ]
}

resource "azurerm_key_vault_secret" "sftp_storage_account_key_vault_secret" {
  name         = "${random_string.name_prefix.result}-${var.sftp_storage_account_key_vault_secret_name}"
  value        = azurerm_storage_account.sftp_storage_account.primary_access_key
  key_vault_id = azurerm_key_vault.avsftp_key_vault.id

  depends_on = [
    azurerm_storage_account.sftp_storage_account,
    azurerm_key_vault.avsftp_key_vault
  ]
}
*/