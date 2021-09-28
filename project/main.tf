terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

variable "azure_devops_project" {}
variable "azure_devops_repo" {}

provider "azurerm" {
  features {}
}

data azurerm_client_config current {}

resource "azuredevops_project" "project" {
  name            = var.azure_devops_project
  description     = "A collection of DevOps Pipelines to showcase working scenarios with Terraform."
  visibility      = "private"
  version_control = "Git"
}

resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.project.id
  name       = var.azure_devops_repo
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = "https://github.com/interrupt-software/azdo-sampler"
  }
}

data "azuredevops_group" "project-contributors" {
  project_id = azuredevops_project.project.id
  name       = "Contributors"
  depends_on = [azuredevops_project.project]
}

resource "azuredevops_git_permissions" "project-git-branch-permissions" {
  project_id    = azuredevops_git_repository.repo.project_id
  repository_id = azuredevops_git_repository.repo.id
  branch_name   = "master"
  principal     = data.azuredevops_group.project-contributors.id
  permissions = {
    RemoveOthersLocks = "Allow"
    GenericContribute = "Allow"
  }
}

# Load a specific Git repository by name
data "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.project.id
  name       = var.azure_devops_repo
  depends_on = [azuredevops_git_repository.repo]
}

output "azuredevops_project_repo_url" {
  value       = data.azuredevops_git_repository.repo.web_url
  description = "The private IP address of the main server instance."
}

output "azuredevops_project_repo_default_branch" {
  value       = data.azuredevops_git_repository.repo.default_branch
  description = "default_branch."
}

output "azuredevops_project_project_id" {
  value = azuredevops_project.project.id
}

output "azuredevops_project_repo_id" {
  value = azuredevops_git_repository.repo.id
}

output "azuredevops_git_repository_repo" {
  value      = {}
  depends_on = [azuredevops_git_repository.repo]
}

resource "azuredevops_serviceendpoint_azurerm" "endpointazure" {
  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "HashiCorp SE AzureRM"
  description               = "Managed by Terraform"
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_client_config.current.subscription_id
  azurerm_subscription_name = "Microsoft Azure DEMO"
}