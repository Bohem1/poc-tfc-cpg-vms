terraform {
  required_version = ">= 0.13.4, < 0.15.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.56.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}
