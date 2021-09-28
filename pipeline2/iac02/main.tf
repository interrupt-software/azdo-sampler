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
resource "azurerm_resource_group" "azdo-sample" {
  name     = "azdo-${random_pet.name.id}"
  location = "Canada Central"
}

output "resource_group_name" {
  value = azurerm_resource_group.azdo-sample.name
}