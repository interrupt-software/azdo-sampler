# Quick Start

Declare the required variables. Fill in the default values for the [Terraform variables](#terraform-variables) in the the [variables.tf](variables.tf) file, and declare the necesary [environment variables](#environment-variables). Here are examples of the values expected.
```bash
# Terraform provider for Azure Resource Manager requirements.
# 
export ARM_CLIENT_ID="1234abcd-56ef-12ab-34cd-567890efabcd"
export ARM_CLIENT_SECRET="1234abcd-56ef-12ab-34cd-567890efabcd"
export ARM_SUBSCRIPTION_ID="1234abcd-56ef-12ab-34cd-567890efabcd"
export ARM_TENANT_ID="1234abcd-56ef-12ab-34cd-567890efabcd"

# Environment variables required for Terraform Providers.
# Note that the values are exclusive to your Azure DevOps organization
# and your Terraform Cloud organization.
#
export AZDO_ORG_SERVICE_URL=https://dev.azure.com/hashicat-azdo
export AZDO_PERSONAL_ACCESS_TOKEN="REPLACE-ME-WITH-YOUR-AZDO-PAT"
export TFE_TOKEN="REPLACE-ME-WITH-YOUR-TFE-TOKEN"

# Terraform variables required to bootstrap the demo.
# Please note that that tne AZDO project name and the
# AZDO repo name are arbitrary and must not need to exist
# already in Azure DevOps.
#
# Also, the values TFC org anme and TFC token are exclusive
# to your Terraform Cloud organization.
#
export TF_VAR_azure_devops_project_name="azdo-primer-101"
export TF_VAR_azure_devops_repo_name="pipeline-starter"
export TF_VAR_azure_devops_org_name="hashicat-azdo"
export TF_VAR_arm_client_secret=$ARM_CLIENT_SECRET
export TF_VAR_tfc_org_name="interrupt-software"
export TF_VAR_tfc_token=$TFE_TOKEN
```

Use the following to stage the working environment.

```
terraform init
```

Use `terraform apply` to build the entire environment. This will deploy all resources included in the source repositories.

```
terraform apply -auto-approve
```

With a successful run, you should be be able to navigate to the your Azure DevOps organization and see the project instantiated. It should look somewhat like this: ![](/img/azdo-welcome.png)

---
Alternatively, you have the option to walk through each module to create an additive rhythm to the demonstration of these assets. With this approach, create the Azure DevOps Project first.

```
terraform apply -target module.project
```

Once you are familiar with the pipelines, you can decide which example to run. For instance, if we are comfortable with the "Hello World, Let's Terraform" example, you can pick that directly as follows:

```
terraform apply -target module.pipeline1
```

The code in [pipeline1/main.tf](pipeline1/main.tf) creates an Azure DevOps Pipeline that references the [pipelines1/azdo-pipeline-01.yml](pipeline1/azdo-pipeline-01.yml) resouce in this repo.


## Required variables

The following variables are used in various places to build the showcase environment. 

### Terraform variables

You can add your defaults to the [variables.tf](variables.tf) file. The alternative is to express these as variables in your working environment. 

| Variable Name | Description |
|--------------:|:------------|
| **azure_devops_project_name** | The intended name for a new Azure DevOps project to create for this exercise. |
| **azure_devops_repo_name** | The target repo to create and then use to host these assets in Azure DevOps.  |
| **azure_devops_org_name** | The name of your Azure DevOps organization. |
| **arm_client_secret** | Used during the `terraform plan` and `terraform apply` steps within a pipeline. |
| **tfc_org_name** | The name of you Organization in Terraform Cloud. |
| **tfc_token** | Used by the pipelines when interacting with Terraform Cloud. |

### Environment variables

These are environment variables that should be expressed in the deployment environment. Please note that secrets must not be written permanently in this deployment.

| Variable Name | Description |
|--------------:|:------------|
| **AZDO_ORG_SERVICE_URL** | Used by the Terraform Provider for Azure DevOps when creating assets for this exercise. |
| **AZDO_PERSONAL_ACCESS_TOKEN** | Used by the Terraform Provider for Azure DevOps when creating assets for this exercise. This must be treated as a secret.|
| **TFE_TOKEN** | Used by the pipelines when interacting with Terraform Cloud. This must be treated as a secret.|
| **ARM_CLIENT_ID<br>ARM_CLIENT_SECRET<br>ARM_SUBSCRIPTION_ID<br>ARM_TENANT_ID** | Account Principal credentials to access Azure Cloud. These must be treated as secrets. |


# Potential errors

There is a potential error during the creation of the pipelines that may occur sporadically. [AzureDevOps Guide](https://www.azuredevopsguide.com/tf400898-an-internal-error-occurred/) writes that the error `TF400898: An Internal Error Occurred` mostly occurs when you are trying to access information from Azure DevOps via some REST API calls. According to Microsoft this is mostly a timeout issue from Azure DevOps. If you try it again after sometime this error seems to goes away.

```bash
Error: error creating resource Build Definition: TF400898: An Internal Error Occurred.
Activity Id: 51d6419d-e7be-41a4-be56-1ba41886d8d5.

  on pipeline3/main.tf line 24, in resource "azuredevops_build_definition" "build3":
  24: resource "azuredevops_build_definition" "build3" {
```

The solution is to issue another `terraform apply` command.


---
From Pipeline #4 and above, we assigning `Collaborator` priviliges to the default service account in the pipeline. The privilege allows the pipeline service account to automatically commit changes to the repository's master branch. To look up the `principal name` for that account and apply the permissions, we use a complicated sammich with hard-coded values. When we modify the Azure DevOps organization, you may find an error:

```bash
Error: Error in function call

  on pipeline4/main.tf line 107, in data "azuredevops_users" "user":
 107:   principal_name = element(data.azuredevops_users.all_users.users[*], 
        index(data.azuredevops_users.all_users.users[*].display_name, 
        "azdo-starter-99 Build Service (hashicat-ado)")).principal_name
    |----------------
    | data.azuredevops_users.all_users.users is set of object with 3 elements

Call to function "index" failed: item not found.
```

The reason for that error is that the call is unable to find the appropriate organization. From the environment variable `$AZDO_ORG_SERVICE_URL` above, note that the organization was exposed as `hashicat-azdo` and the code references `hashicat-ado`.

🗹 TO-DO: Code more better.

Update (09/08/21) - This is fixed. We added variables to handle the dependency.

```hcl 
data "azuredevops_users" "user" {
  principal_name = element(data.azuredevops_users.all_users.users[*], 
      index(data.azuredevops_users.all_users.users[*].display_name, 
      "${var.project_name} Build Service (${var.org_name})")).principal_name
}
```

We're leaving this here in case we run into similar issues. If so, please report them.
<br>

# About the Providers

Each provider has various prerequesite data points that need to be expressed as enviroment variables as part of the initial deployment.

| Provider | Description | Environment variables |  
|----------:|:-------------|:-------------|
| **Azure Resource Manager** | Provisions Azure Cloud resources through build pipelines. Also provides authentication for Azure subscription services for Azure DevOps tasks. |ARM_CLIENT_ID<br>ARM_CLIENT_SECRET<br>ARM_SUBSCRIPTION_ID<br>ARM_TENANT_ID |
| **Azure DevOps** | Create master project, respostories and build pipelines. We also use it update account permissions for pipeline users | AZDO_ORG_SERVICE_URL<br>AZDO_PERSONAL_ACCESS_TOKEN |
| **Terraform** | Sets up and configures Terraform Cloud workspaces, and links pipeline deployments to the appropriate workspaces. | TFE_TOKEN |
| **Random** | Creates random pet names. | none |

In addition, the IaC deployments require the pass-thru of two specific variables that suppor the pipeline tasks. These are required by the work carried during the execution of `terraform plan` and `terraform apply` steps but are not strictly required to build the demo environment.

- **TF_VAR_arm_client_secret** is used during the `terraform plan` and `terraform apply` steps within a pipeline. While the credentials can be inhereted from the triggering account (human/you) with `az login`, the instrospection of data source `data azurerm_client_config current {}` does not expose the `client secret`.

### Azure Resource Manager

It is true that we can avoid exposing these variables with `az login` to authenticate with your Azure Active Directory account instead of an Account Principal. Please note, however, that we are not using these credentials for this demo environment at all. Instead, we are publishing these to the pipelines as local secrets. The pipelines use these credentials to procure Azure services. We want the flexibility to depecreate these credentials once the demonstration exercise is completed.

In addition, we also plant the credentials in Terraform Cloud workspaces as environment secrets. The Azure authentication process from a Terraform Cloud workspace requires account principal credentials. *Please note the the requirement for `TF_VAR_arm_client_secret` below*.

```bash
export ARM_CLIENT_ID="1234abcd-56ef-12ab-34cd-567890efabcd"
export ARM_CLIENT_SECRET="1234abcd-56ef-12ab-34cd-567890efabcd"
export ARM_SUBSCRIPTION_ID="1234abcd-56ef-12ab-34cd-567890efabcd"
export ARM_TENANT_ID="1234abcd-56ef-12ab-34cd-567890efabcd"
```

### Azure DevOps

Create an Azure DevOps personal access token (PAT) to support remote operations with the Terraform Azure DevOps provider. There is a handy guide on how to create personal access tokens in the [Azure DevOps Documentation](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page#create-a-pat). 

Expose your Azure DevOps PAT and organization URL as follows:

```bash
export AZDO_PERSONAL_ACCESS_TOKEN="##########"
export AZDO_ORG_SERVICE_URL=https://dev.azure.com/hashicat-azdo
```

### Terraform Cloud

This is not strictly required to build the demo environment. We are using it in this manner to maintain the recommended convention for exposure. Some people like little tomatoes and some tomatillos.

```bash
export TFE_TOKEN="##########"
```

The following variables are required for the Terraform and environment that run in various Azure DevOps pipeline tasks. Please note that `TF_VAR_azure_devops_org_name` is here to solve the dependency names on the pipeline service account.

### Pipeline inheritance

```bash
export TF_VAR_arm_client_secret=$ARM_CLIENT_SECRET
export TF_VAR_tfc_token=$TFE_TOKEN
export TF_VAR_azure_devops_org_name="hashicat-azdo"
```
