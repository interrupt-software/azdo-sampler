terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "random_pet" "name" {
  length = 2
}

# Create a resource group
resource "azurerm_resource_group" "ado-sample" {
  name     = "azdo-${random_pet.name.id}"
  location = "Canada Central"
}

resource "azurerm_storage_account" "tfstate" {
  name                            = lower("tfstate${formatdate("DDMMMYYYYHHmmZZZ", timestamp())}")
  resource_group_name             = azurerm_resource_group.ado-sample.name
  location                        = azurerm_resource_group.ado-sample.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = true

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}

output "resource_group_id" {
  value = azurerm_resource_group.ado-sample.id
}

output "resource_group_name" {
  value = azurerm_resource_group.ado-sample.name
}

output "storage_account_id" {
  value = azurerm_storage_account.tfstate.id
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

// output "now_now" {
//   value = formatdate("DDMMMYYYYhhmmZZZ", timestamp())
// }
