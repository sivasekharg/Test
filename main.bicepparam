using './main.bicep'

// Change these before deployment. Storage account names must be globally unique.
param resourceGroupName = 'rg-storage-centralindia'
param storageAccountName = 'REPLACE_WITH_UNIQUE_NAME'
param location = 'centralindia'
param tags = {
  environment: 'production'
  managedBy: 'bicep'
}
