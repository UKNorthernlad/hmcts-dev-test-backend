####################
# Common variables
####################
variable "resource_group_name" {
  description = "The name of the resource group that will contain the core infrastructure resources"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 2
    error_message = "Resource group name must be at least 3 characters."
  }
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "uksouth"

  validation {
    condition     = contains(["uksouth", "ukwest", "westeurope"], lower(var.location))
    error_message = "Location must be one of: uksouth, ukwest, westeurope."
  }
}


####################
# Network variables
####################
variable "vnet_cidr" {
  description = "The CIDR block for the virtual network"
  type        = string
  default     = "192.168.0.0/16"

  validation {
    condition     = can(cidrhost(var.vnet_cidr, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "192.168.1.0/24"

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}


####################
# Database variables
####################
variable "server_name" {
  description = "The name of the PostgreSQL flexible server"
  type        = string
  default     = "pg-flexi-01"

  validation {
    condition     = length(var.server_name) > 5
    error_message = "Server name must be at least 6 characters."
  }
}

variable "sku_name" {
  description = "The Azure SKU for the PostgreSQL flexible server"
  type        = string
  default     = "Standard_B1ms"

  validation {
    condition     = contains(["Standard_B1ms", "Standard_D4_v3"], lower(var.sku_name))
    error_message = "Location must be one of: uksouth, ukwest, westeurope."
  }
}

variable "administrator_login" {
  description = "The administrator login for the PostgreSQL flexible server"
  type        = string

  validation {
    condition     = length(var.administrator_login) > 5
    error_message = "Admin login name must be at least 6 characters."
  }
}

variable "administrator_password" {
  description = "The administrator password for the PostgreSQL flexible server"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.administrator_password) > 5
    error_message = "Admin password must be at least 6 characters."
  }
}

variable "app_db_name" {
  description = "The name of the application database"
  type        = string
  default     = "appdb"

  validation {
    condition     = length(var.app_db_name) > 3
    error_message = "Application database name must be at least 4 characters."
  }
}

variable "db_host" {
  type        = string
  description = "Host name for the database."
}

variable "db_port" {
  type        = string
  description = "Port for the database."
}

variable "db_name" {
  type        = string
  description = "Name of the database."
}

variable "db_options" {
  type        = string
  description = "Options for the database."
}

variable "db_user_name" {
  type        = string
  description = "Username for the database."
}

variable "db_password" {
  type        = string
  description = "Password for the database."
}


####################
# Container App variables and app configuration
####################
variable "name" {
  type        = string
  description = "Name of the Azure Container App."

  validation {
    condition     = length(var.name) > 5
    error_message = "Container app name must be at least 6 characters."
  }
}

variable "environment_name" {
  type        = string
  description = "Name of the Container Apps environment."
}

variable "container_image" {
  type        = string
  description = "Container image to deploy."

  validation {
    condition = can(

      // Docker image + tag pattern
      // "^[a-z0-9]+(?:[._-][a-z0-9]+)*"          // repo (e.g., library, mycompany)
      // "/[a-z0-9]+(?:[._-][a-z0-9]+)*"          // image name
      // ":[A-Za-z0-9][A-Za-z0-9._-]{0,127}$"     // tag

      regex(
        "^[a-z0-9]+(?:[._-][a-z0-9]+)*/[a-z0-9]+(?:[._-][a-z0-9]+)*:[A-Za-z0-9][A-Za-z0-9._-]{0,127}$",
        var.container_image
      )
    )

    error_message = "container_image must be in the format 'repo/name:tag', e.g. 'nginx/nginx:1.25.0'."
  }

}

variable "cpu" {
  type        = number
  description = "CPU cores for the container."
  default     = 0.5

  validation {
    condition     = can(tonumber(var.cpu))
    error_message = "float_value must be a valid number (integer or float)."
  }
}

variable "memory" {
  type        = string
  description = "Memory allocation (e.g., 1Gi). The value must be a string with a number followed by 'Gi' or 'Mi'."
  default     = "1Gi"

  validation {
    condition = can(

      regex(
        "^[123456789](Gi|Mi)$",
        var.memory
      )
    )

    error_message = "Memory must be in the format 'xGi' or 'xMi' where 'x' is a number from 1 to 9."
  }
}

####################
# Container App variables and app configuration
####################
variable "kvname" {
  type        = string
  description = "The name of the key vault to create"
  default     = "examplekeyvault"
}