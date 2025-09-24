terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
 subscription_id = "43d74b2b-f6c0-4c6b-9e12-1095e6955562"
}


provider "azurerm" {
  features {}
  subscription_id = var.subscription_platform
 alias = "sub-Platform"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_prod-01
  alias = "sub-Prod-01"
}