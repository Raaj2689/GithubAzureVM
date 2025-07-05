terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Remove or comment out the duplicate provider block below if you already have it in main.tf
# If you want to specify credentials, use this format:

# provider "azurerm" {
#   features {}
#   client_id       = var.client_id
#   client_secret   = var.client_secret
#   tenant_id       = var.tenant_id
#   subscription_id = var.subscription_id
# }
