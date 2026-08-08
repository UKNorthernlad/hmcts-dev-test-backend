terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.0.1"
    }
  }
  #backend "azurerm" {
  #  resource_group_name   = "rg-tfstate"
  #  storage_account_name  = "sttfstateprod"
  #  container_name        = "tfstate"
  #  key                   = "prod.terraform.tfstate"
  #}
}

provider "azurerm" {
  features {}
}

#######################
#######################


#
# Main resource group
#
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#
# Network
#
module "network" {
  source = "./modules/network"

  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  subnet_cidr         = var.subnet_cidr

  depends_on = [azurerm_resource_group.rg]
}

output "network_vnet_id" {
  value = module.network.vnet_id
}

output "network_subnet_id" {
  value = module.network.subnet_id
}


#
# Database
#
module "database" {
  source = "./modules/database"

  resource_group_name    = var.resource_group_name
  location               = var.location
  vnet_cidr              = var.vnet_cidr
  subnet_cidr            = var.subnet_cidr
  server_name            = var.server_name
  sku_name               = var.sku_name
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  app_db_name            = var.app_db_name

  depends_on = [azurerm_resource_group.rg]
}


#
# Compute
#
module "container_app" {
  source = "./modules/compute"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  container_image = var.container_image
  db_host         = var.db_host
  db_port         = var.db_port
  db_name         = var.db_name
  db_options      = var.db_options
  db_user_name    = var.db_user_name
  db_password     = var.db_password
}

#
# Keyvault and secrets
#
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = var.resource_group_name
  location            = var.location
  kvname              = var.kvname

}

