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

variable "server_name" {
  description = "The name of the PostgreSQL flexible server"
  type        = string
}

variable "sku_name" {
  description = "The Azure SKU for the PostgreSQL flexible server"
  type        = string
}

variable "postgresql_version" {
  description = "The PostgreSQL version for the flexible server"
  type        = string
  default     = "18"
}

variable "storage_mb" {
  type        = number
  description = "Storage size in MB."
  default     = 32768
}

variable "administrator_login" {
  description = "The administrator login for the PostgreSQL flexible server"
  type        = string
  default     = "pgadmin"
}

variable "administrator_password" {
  description = "The administrator password for the PostgreSQL flexible server"
  type        = string
}




variable "backup_retention_days" {
  description = "The number of days to retain backups for the PostgreSQL flexible server"
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Whether geo-redundant backups are enabled for the PostgreSQL flexible server"
  type        = bool
  default     = false
}

variable "zone" {
  description = "The zone for the PostgreSQL flexible server"
  type        = string
  default     = "1"
}



variable "app_db_name" {
  description = "The name of the application database"
  type        = string
  default     = "appdb"
}

variable "app_db_charset" {
  description = "The character set for the application database"
  type        = string
  default     = "UTF8"
}

variable "app_db_collation" {
  description = "The collation for the application database"
  type        = string
  default     = "en_US.UTF-8"
}


