# Azure Storage Account deployment

This Bicep template creates a resource group and a secure, general-purpose v2 Storage Account in **Central India**. It uses locally redundant storage (Standard_LRS), disables anonymous blob access and shared-key access, and requires HTTPS with TLS 1.2 or later.

## Before deploying

Edit `main.bicepparam` and replace `REPLACE_WITH_UNIQUE_NAME` with a globally unique storage-account name. Azure permits only 3–24 lowercase letters and numbers.

Sign in and select the intended subscription:

```sh
az login
az account set --subscription '<subscription-id-or-name>'
```

## Validate and deploy

```sh
az deployment sub validate \
  --location centralindia \
  --template-file main.bicep \
  --parameters main.bicepparam

az deployment sub create \
  --name storage-centralindia \
  --location centralindia \
  --template-file main.bicep \
  --parameters main.bicepparam
```

The `--location` on the deployment command stores Azure's deployment metadata; the actual resources use the `location` parameter.

## Current development VM

The Azure CLI session is configured for subscription `Azure subscription 1`
(`c931b75a-66db-4cf9-baa9-68fd55ea9cab`). The CLI installed for this workspace
is available at `.azure-cli/bin/az`.

| Setting | Value |
| --- | --- |
| Resource group | `rg-free-vm-centralindia` |
| VM | `freevmci` |
| Region | `centralindia` |
| Image | Ubuntu 22.04 LTS (`Ubuntu2204`) |
| Size | `Standard_B2ats_v2` |
| Disk | 30 GiB, `Standard_LRS` |
| Public IP | `20.219.28.139` |
| SSH user | `azureuser` |
| SSH private key | `~/.ssh/id_rsa` |
| SSH firewall rule | TCP 22 from `49.204.228.252/32` only |

Connect with:

```sh
ssh azureuser@20.219.28.139
```

If the local public IP changes, update the firewall rule before connecting:

```sh
.azure-cli/bin/az network nsg rule update \
  --resource-group rg-free-vm-centralindia \
  --nsg-name nsg-freevm \
  --name AllowSSHFromMyIP \
  --source-address-prefixes '<new-public-ip>/32'
```

To stop compute billing while preserving the VM, run:

```sh
.azure-cli/bin/az vm deallocate \
  --resource-group rg-free-vm-centralindia \
  --name freevmci
```
