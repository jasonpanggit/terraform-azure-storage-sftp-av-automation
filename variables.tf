variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

# Location
variable "location" {}

# Resource groups
variable "resource_group_name" {}

# VNets
variable "avsftp_vnet_name" {}
variable "avsftp_vnet_address_space" {}

# AV Subnets
variable "avsftp_vnet_function_subnet_name" {}
variable "avsftp_vnet_vm_subnet_name" {}
variable "avsftp_vnet_sftp_subnet_name" {}
variable "avsftp_vnet_function_subnet_address_prefixes" {}
variable "avsftp_vnet_vm_subnet_address_prefixes" {}
variable "avsftp_vnet_sftp_subnet_address_prefixes" {}

# Storage account type
variable "av_storage_account_name" {}
variable "av_storage_account_kind" {}
variable "av_storage_account_tier" {}
variable "av_storage_account_replication_type" {}

variable "sftp_storage_account_name" {}
variable "sftp_storage_account_kind" {}
variable "sftp_storage_account_tier" {}
variable "sftp_storage_account_replication_type" {}
variable "sftp_storage_accounts_new_files_container_name" {}
variable "sftp_storage_accounts_clean_files_container_name" {}
variable "sftp_storage_accounts_quarantine_files_container_name" {}

# Key Vaults
#variable "avsftp_key_vault_name" {}
#variable "av_storage_account_key_vault_secret_name" {}
#variable "sftp_storage_account_key_vault_secret_name" {}

# App Services
variable "av_app_service_plan_name" {}
variable "av_function_app_name" {}

# Virtual Machines
variable "av_vm_name" {}
variable "av_vm_size" {}
variable "av_vm_computer_name" {}
variable "av_vm_username" {}
variable "av_vm_password" {}
variable "av_vm_ip_config_name" {}
variable "av_vm_osdisk_name" {}
variable "av_vm_osdisk_caching" {}
variable "av_vm_osdisk_storage_account_type" {}
variable "av_vm_osdisk_size" {}
variable "av_vm_source_img_ref_publisher" {}
variable "av_vm_source_img_ref_offer" {}
variable "av_vm_source_img_ref_sku" {}
variable "av_vm_source_img_ref_version" {}

# Network Interfaces
variable "av_vm_network_interface_name" {}

# NSGs 
variable "avsftp_nsg_name" {}

# Zip files for function and AV scanner
variable "scan_http_server_url" {}
variable "vm_init_script_url" {}
variable "functionapp_zip" {}