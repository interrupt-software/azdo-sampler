variable "azurerm_resource_group_name" {
  description = "Random name for the testing AZ Resource Group"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "Canada Central"
}

variable "tags" {
  type = map

  default = {
    Subscription = "Customer in Azure"
    Environment  = "NodeJS App"
    Owner        = "Hashi Neko"
    Purpose      = "HashiTalks Canada"
    Email        = "neko@hashicorp.com"
    DoNotDelete  = "False"
    Panic        = "Don't"
    TTL          = "60min"
  }

  description = "Basic tags"
}