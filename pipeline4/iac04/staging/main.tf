
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    tfe = {
      version = "~> 0.26.0"
    }
  }
}

variable "tfc_organization" {}
variable "tfc_workspace_name" {}
variable "arm_client_secret" {}

provider "azurerm" {
  features {}
}

provider "tfe" {
}

data azurerm_client_config current {}

resource "tfe_workspace" "test" {
  name         = var.tfc_workspace_name
  organization = var.tfc_organization
  tag_names    = ["demo", "azdo"]
}

resource "tfe_variable" "arm_client_id" {
  workspace_id = tfe_workspace.test.id
  key          = "ARM_CLIENT_ID"
  value        = data.azurerm_client_config.current.client_id
  category     = "env"
  sensitive    = true
}

resource "tfe_variable" "arm_client_secret" {
  workspace_id = tfe_workspace.test.id
  key          = "ARM_CLIENT_SECRET"
  value        = var.arm_client_secret
  category     = "env"
  sensitive    = true
}

resource "tfe_variable" "arm_subscription_id" {
  workspace_id = tfe_workspace.test.id
  key          = "ARM_SUBSCRIPTION_ID"
  value        = data.azurerm_client_config.current.subscription_id
  category     = "env"
  sensitive    = true
}

resource "tfe_variable" "arm_tenant_id" {
  workspace_id = tfe_workspace.test.id
  key          = "ARM_TENANT_ID"
  value        = data.azurerm_client_config.current.tenant_id
  category     = "env"
  sensitive    = true
}