variable "resource_group_name" {
  description = "The name of the resource group that will contain the core infrastructure resources"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "name" {
  description = "The name of the container app"
  type        = string
}

variable "container_image" {
  description = "The container image to use for the container app. Format is <registry>/<repository>:<tag>"
  type        = string
}

variable "db_host" {
  description = "The hostname of the database"
  type        = string
}
variable "db_port" {
  description = "The port of the database"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_options" {
  description = "The options for the database"
  type        = string
}

variable "db_user_name" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}







