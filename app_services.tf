resource "azurerm_service_plan" "av_app_service_plan" {
  name                = "${random_string.name_prefix.result}-${var.av_app_service_plan_name}"
  resource_group_name = azurerm_resource_group.avsftp_rg.name
  location            = azurerm_resource_group.avsftp_rg.location
  #kind                = "FunctionApp"
  sku_name = "S1"
  os_type  = "Windows"
  #sku {  
  #  tier = "Standard"
  #  size = "S1"
  #}
  depends_on = [azurerm_resource_group.avsftp_rg]
}

resource "azurerm_windows_function_app" "av_function_app" {
  name                = "${random_string.name_prefix.result}-${var.av_function_app_name}"
  resource_group_name = azurerm_resource_group.avsftp_rg.name
  location            = azurerm_resource_group.avsftp_rg.location
  service_plan_id     = azurerm_service_plan.av_app_service_plan.id

  identity {
    type = "SystemAssigned"
  }

  # Azure Function doesn't accept Key Vault Reference for Storage Connection String for consumption plan
  # https://github.com/hashicorp/terraform-provider-azurerm/issues/7434
  /*
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.av_function_app_user_assigned_identity.id]
  }
  key_vault_reference_identity_id = azurerm_user_assigned_identity.av_function_app_user_assigned_identity.id
  */

  storage_account_name       = azurerm_storage_account.av_storage_account.name
  storage_account_access_key = azurerm_storage_account.av_storage_account.primary_access_key

  app_settings = {
    "clean_files_container_name"               = var.sftp_storage_accounts_clean_files_container_name
    "quarantine_files_container_name"          = var.sftp_storage_accounts_quarantine_files_container_name
    "new_files_container_name"                 = var.sftp_storage_accounts_new_files_container_name
    "AzureWebJobsStorage"                      = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.av_storage_account.name};AccountKey=${azurerm_storage_account.av_storage_account.primary_access_key};EndpointSuffix=core.windows.net"
    "FUNCTIONS_WORKER_RUNTIME"                 = "dotnet"
    "FUNCTIONS_EXTENSION_VERSION"              = "~4"
    "WEBSITE_NODE_DEFAULT_VERSION"             = "~10"
    "WEBSITE_CONTENTSHARE"                     = var.av_function_app_name
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.av_storage_account.name};AccountKey=${azurerm_storage_account.av_storage_account.primary_access_key};EndpointSuffix=core.windows.net"
    HASH                                       = "${base64encode(filesha256("${var.functionapp_zip}"))}"
    WEBSITE_RUN_FROM_PACKAGE                   = "https://${azurerm_storage_account.av_storage_account.name}.blob.core.windows.net/${azurerm_storage_container.deployment.name}/${azurerm_storage_blob.functionapp_zip.name}${data.azurerm_storage_account_sas.sas.sas}"
    "av_vm_host"                               = azurerm_windows_virtual_machine.av_vm.private_ip_address
    "av_vm_port"                               = "443",
    "sftp_storage_conn"                        = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.sftp_storage_account.name};AccountKey=${azurerm_storage_account.sftp_storage_account.primary_access_key};EndpointSuffix=core.windows.net"
  }

  # using KV reference for storage access
  /*
  app_settings = {
    "cleanContainerName"                       = var.sftp_storage_accounts_clean_files_container_name
    "malwareContainerName"                     = var.sftp_storage_accounts_quarantine_files_container_name
    "targetContainerName"                      = var.sftp_storage_accounts_new_files_container_name
    "AzureWebJobsStorage"                      = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.av_storage_account_key_vault_secret.id})"
    "FUNCTIONS_WORKER_RUNTIME"                 = "~3"
    "FUNCTIONS_EXTENSION_VERSION"              = "~3"
    "WEBSITE_NODE_DEFAULT_VERSION"             = "~10"
    "WEBSITE_CONTENTSHARE"                     = var.av_function_app_name
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.av_storage_account_key_vault_secret.id})"
    "WEBSITE_RUN_FROM_PACKAGE"                 = "1"
    #"WEBSITE_SKIP_CONTENTSHARE_VALIDATION"     = "1"
    "av_vm_host"                     = azurerm_windows_virtual_machine.av_vm.private_ip_address
    "av_vm_port"                     = "443",
    "sftp_storage_conn"                       = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.sftp_storage_account_key_vault_secret.id})"
  }
  */

  site_config {

  }

  depends_on = [
    azurerm_resource_group.avsftp_rg,
    azurerm_service_plan.av_app_service_plan,
    azurerm_storage_account.av_storage_account,
    azurerm_storage_account.sftp_storage_account,
    azurerm_windows_virtual_machine.av_vm
    #azurerm_key_vault_secret.av_storage_account_key_vault_secret,
    #azurerm_key_vault_secret.sftp_storage_account_key_vault_secret,
    #azurerm_user_assigned_identity.av_function_app_user_assigned_identity
  ]
}

resource "azurerm_app_service_virtual_network_swift_connection" "av_function_app_vnet_integration" {
  app_service_id = azurerm_windows_function_app.av_function_app.id
  subnet_id      = azurerm_subnet.avsftp_vnet_function_subnet.id

  depends_on = [
    azurerm_windows_function_app.av_function_app
  ]
}
