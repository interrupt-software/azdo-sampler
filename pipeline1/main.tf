terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

variable "project_id" {}
variable "repo_id" {}
variable "branch_name" {}

resource "azuredevops_build_definition" "build1" {
  project_id = var.project_id
  name       = "01 - Hello World, Let's Terraform"
  path       = "\\pipelines"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = var.repo_id
    branch_name = var.branch_name
    yml_path    = "pipeline1/azdo-pipeline-01.yml"
  }
}
