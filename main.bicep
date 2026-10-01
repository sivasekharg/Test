targetScope = 'subscription'

@description('Name of the resource group to create.')
param resourceGroupName string

@description('Globally unique, lowercase name for the storage account (3-24 alphanumeric characters).')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Azure region for the resource group and storage account.')
@allowed([
  'centralindia'
  'southindia'
  'westindia'
])
param location string = 'centralindia'

@description('Tags applied to both resources.')
param tags object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  scope: resourceGroup
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: true
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
  }
}

output resourceGroupId string = resourceGroup.id
output storageAccountId string = storageAccount.id
output storageAccountBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob
