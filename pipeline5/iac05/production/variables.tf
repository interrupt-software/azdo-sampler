variable "azurerm_resource_group_name" {}

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
    Purpose      = "POC Test"
    Email        = "neko@hashicorp.com"
    DoNotDelete  = "False"
    Panic        = "Don't"
    TTL          = "60min"
  }

  description = "Basic tags"
}