# Mandatory variables to be added by ServiceNow integration

variable "subsId" {
}

variable "clientId" {
}

variable "clientSecret" {
}

variable "tenantId" {
}

## Variables using input from ServiceNow
variable "owner" {
  description = "The name of the requester / on behalf of value"
  type        = string
}

variable "costcenter" {
  description = "The value of the costcenter if provided by ServiceNow"
  type        = string
  default     = false
}

variable "stackname" {
  description = "A random string from ServiceNow"
  type        = string
}

variable "projectname" {
  description = "The value of the project name if provided by ServiceNow"
  type        = string
  default     = false
}

variable "machine_count" {
  description = "The number of machines to create"
  type        = number
  default     = 1
}

data "azurerm_virtual_network" "poc" {
  name                = "vnet-nebula-poc"
  resource_group_name = "rg-nebula-poc-network"
}

data "azurerm_subnet" "internal" {
  name                 = "terraform-node-subnet"
  resource_group_name  = "rg-nebula-poc-network"
  virtual_network_name = data.azurerm_virtual_network.poc.name
}

data "azurerm_key_vault" "common" {
  name                = "kv-nebula-poc"
  resource_group_name = "rg-nebula-poc-common"
}
