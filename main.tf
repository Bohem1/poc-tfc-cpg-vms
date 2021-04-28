
locals {
  name1  = substr(lower(replace(azurerm_resource_group.this.name, "/[^0-9a-zA-Z]/", "")), 0, 22)
  saname = format("sa%s%s", replace(local.name1, "/^rg/", ""), random_string.project.result)

}

resource "random_string" "project" {
  length  = 5
  lower   = true
  number  = true
  special = false
}

resource "azurerm_resource_group" "this" {
  name     = "poc-servicenow-case1-${random_string.project.result}-rg"
  location = "westeurope"
  tags = {
    CostCenter  = var.costcenter
    ProjectName = var.projectname
  }
}


## Create 3 storage accounts

resource "azurerm_storage_account" "this" {
  count               = 3
  name                = "${local.saname}[count.index]"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    CostCenter      = var.costcenter
    ProjectName     = var.projectname
    deploymentindex = [count.index]
  }

}
