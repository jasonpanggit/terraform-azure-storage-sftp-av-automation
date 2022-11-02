# Terraform template for Azure Storage SFTP with real-time antivirus scanning

## Project Structure
zip - containing the function app zip file which will be uploaded to deployment-files container in AV storage account and used in WEBSITE_RUN_FROM_PACKAGE

## Deployment Steps
1. Use the following command to clone the repo
    git clone https://github.com/jasonpanggit/terraform-azure-storage-sftp-av-automation.git
2. Rename avsftp.tfvars.template to avsftp.tfvars and change the necessary parameters (Important: remember to set the expiry date of the SAS token used for function app deployment)
3. Go to SFTP storage account resource in Azure portal, open SFTP blade, enable SFTP and add local user with SSH password/key
    
## Not supported/yet to do
1. Enabling SFTP (need to manually enable it in Azure Portal) and adding local users
2. Saving storage access details in Azure Key Vault (MSI cannot be used in function app because key vault access policy creation requires function app to be created first in order to get the object id) 

## Reference
This repository is based on https://github.com/Azure/azure-storage-av-automation which is using ARM template
