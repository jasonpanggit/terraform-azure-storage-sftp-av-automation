# Terraform template for Azure Storage SFTP with real-time antivirus scanning
##### Authored by: Jason Pang | Updated: Nov 2nd, 2022  

Terraform template for Azure Storage SFTP with real-time antivirus scanning is an terraform template (converted from https://github.com/Azure/azure-storage-av-automation which is an ARM template) that provisions resources in your environment in order to protect an Azure blob container from malware by scanning every blob that’s uploaded via SFTP. The project consists of a function triggered when files are uploaded to or updated in a Blob storage container, and a Windows VM that utilizes Microsoft Defender Antivirus to scan the uploaded/updated files in real-time.

<img src="https://raw.githubusercontent.com/Azure/azure-storage-av-automation/main/AvAutoSystem.png"/>

For each blob uploaded to the protected container, the function will send the blob to the VM for scanning and change the blob location according to the scan results:
* If the blob is clean, it’s moved to the clean-files container
* If it contains malware it’s moved to the quarantine-files container

The Azure function and the VM are connected through a virtual network and communicate using HTTPS requests.  

List of created resources:
1. Function App
2. App Service Plan
3. Virtual Network
4. Network Security Group
5. Storage Accounts - for the function app and SFTP
6. Virtual Machine - for scanning the uploaded/updated files using Microsoft Defender Antivirus
7. Disk - Storage for the VM
8. Network Interface - NIC for the VM

## Project Structure
zip folder - containing the function app zip file which will be uploaded to deployment-files container in AV storage account and used in WEBSITE_RUN_FROM_PACKAGE
avsftp.tfvars.template - TRVARS template containing sample parameters values

## Deployment Steps
1. Use the following command to clone the repo
   ```
   git clone https://github.com/jasonpanggit/terraform-azure-storage-sftp-av-automation.git
   ``` 
2. Rename avsftp.tfvars.template to avsftp.tfvars and change the necessary parameters (Important: remember to set the expiry date of the SAS token used for function app deployment)
3. Go to SFTP storage account resource in Azure portal, open SFTP blade, enable SFTP and add local user with SSH password/key
    
## Not supported/yet to do
1. Enabling SFTP (need to manually enable it in Azure Portal) and adding local users
2. Saving storage access details in Azure Key Vault (MSI cannot be used in function app because key vault access policy creation requires function app to be created first in order to get the object id) 

## Credits/References
This repository is based on https://github.com/Azure/azure-storage-av-automation which is using ARM template.
