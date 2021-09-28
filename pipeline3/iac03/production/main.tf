terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    resource_group_name  = "REPLACE_RESOURCE_GROUP_NAME"
    storage_account_name = "REPLACE_STORAGE_ACCOUNT_NAME"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Reference a resource group
data "azurerm_resource_group" "azdo-sample" {
  name = "REPLACE_RESOURCE_GROUP_NAME"
}

resource "azurerm_network_security_group" "azdo-sample" {
  name                = "acceptanceTestSecurityGroup1"
  location            = data.azurerm_resource_group.azdo-sample.location
  resource_group_name = data.azurerm_resource_group.azdo-sample.name

  security_rule {
    name                       = "BadlyAllAllowed"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}
