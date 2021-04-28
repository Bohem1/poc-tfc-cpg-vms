
locals {
  name1  = substr(lower(replace(azurerm_resource_group.this.name, "/[^0-9a-zA-Z]/", "")), 0, 24)
  saname = format("sa%s%s", replace(local.name1, "/^rg/", ""), random_string.project.result)

}

resource "random_string" "project" {
  length  = 5
  lower   = true
  number  = true
  special = false
}

resource "azurerm_resource_group" "this" {
  name     = "poc-servicenow-case1-rg"
  location = "westeurope"
}


## Create 3 storage accounts

resource "azurerm_storage_account" "this" {
  name                = local.saname
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    CostCenter  = var.costcenter
    ProjectName = var.projectname
  }

}

resource "azurerm_container_group" "aci-example" {
  name                = "poc-${randdom_string.ptoject.result}${var.prefix}-examplecont"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  ip_address_type     = "public"
  dns_name_label      = "${var.prefix}-examplecont"
  os_type             = "linux"

  container {
    name   = "hw"
    image  = "microsoft/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"
    port   = "80"
  }

  container {
    name   = "sidecar"
    image  = "microsoft/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "testing"
  }
}
