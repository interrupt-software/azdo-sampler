module "project" {
  source               = "./project"
  azure_devops_project = var.azure_devops_project_name
  azure_devops_repo    = var.azure_devops_repo_name
}

module "pipeline1" {
  source      = "./pipeline1"
  project_id  = module.project.azuredevops_project_project_id
  repo_id     = module.project.azuredevops_project_repo_id
  branch_name = module.project.azuredevops_project_repo_default_branch
}


module "pipeline2" {
  source            = "./pipeline2"
  project_id        = module.project.azuredevops_project_project_id
  repo_id           = module.project.azuredevops_project_repo_id
  branch_name       = module.project.azuredevops_project_repo_default_branch
  arm_client_secret = var.arm_client_secret
}

module "pipeline3" {
  source            = "./pipeline3"
  project_id        = module.project.azuredevops_project_project_id
  repo_id           = module.project.azuredevops_project_repo_id
  branch_name       = module.project.azuredevops_project_repo_default_branch
  arm_client_secret = var.arm_client_secret
}

module "pipeline4" {
  source            = "./pipeline4"
  project_id        = module.project.azuredevops_project_project_id
  repo_id           = module.project.azuredevops_project_repo_id
  branch_name       = module.project.azuredevops_project_repo_default_branch
  project_name      = var.azure_devops_project_name
  repo_name         = var.azure_devops_repo_name
  org_name          = var.azure_devops_org_name
  arm_client_secret = var.arm_client_secret
  tfc_org_name      = var.tfc_org_name
  tfc_token         = var.tfc_token

  azuredevops_users_depends_on = [
    module.project.azuredevops_git_repository_repo,
    module.pipeline4.azuredevops_build_definition_build
  ]
}

module "pipeline5" {
  source            = "./pipeline5"
  project_id        = module.project.azuredevops_project_project_id
  repo_id           = module.project.azuredevops_project_repo_id
  branch_name       = module.project.azuredevops_project_repo_default_branch
  project_name      = var.azure_devops_project_name
  repo_name         = var.azure_devops_repo_name
  org_name          = var.azure_devops_org_name
  arm_client_secret = var.arm_client_secret
  tfc_org_name      = var.tfc_org_name
  tfc_token         = var.tfc_token

  azuredevops_users_depends_on = [
    module.project.azuredevops_git_repository_repo,
    module.pipeline5.azuredevops_build_definition_build
  ]
}