terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "random_pet" "name" {
  length = 2
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azdo-sample" {
  name     = var.azurerm_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_network_security_group" "azdo-sample" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.azdo-sample.location
  resource_group_name = azurerm_resource_group.azdo-sample.name

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
