variable "resource_group_name" {
  description = "The name of the resource group that will contain the core infrastructure resources"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "vnet_cidr" {
  description = "The CIDR block for the virtual network"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
}
