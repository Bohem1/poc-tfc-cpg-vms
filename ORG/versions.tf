terraform {
  required_version = ">= 0.13.4, < 14.0.0"
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

provider "random" {
}

provider "azurerm" {
  features {}
}
