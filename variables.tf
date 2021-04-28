## Get variables:

variable "costcenter" {
  description = "Provide a value for CostCenter"
  type        = string
  default     = ""
}

variable "projectname" {
  description = "Provide a value for Project Name"
  type        = string
  default     = "POC-ServiceNow"
}

variable "prefix" {
  type        = string
  description = "string to be used as prefix for containerstuff"
  default     = "mommy"
}

## Variables to configure ServiceNow provider
# Values are provided by ServiceNow
variable "subsId" {
}

variable "clientId" {
}

variable "clientSecret" {
}

variable "tenantId" {
}


