
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.azurerm_resource_group_name}-nodejs"
  location = var.location
  tags     = var.tags
}

resource "azurerm_service_plan" "main" {
  name                = "${var.azurerm_resource_group_name}-nodejs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = var.tags
}

resource "azurerm_app_service" "main" {
  name                = "${var.azurerm_resource_group_name}-nodejs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_service_plan.main.id

  site_config {
    linux_fx_version = "NODE|14-lts"
  }
}

output "app_service_name" {
  value = azurerm_app_service.main.name
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.main.default_site_hostname}"
}
