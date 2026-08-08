variable "resource_group_name" {
  description = "The name of the resource group that will contain the core infrastructure resources"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "kvname" {
  description = "The name of the key vault to create"
  type        = string
}