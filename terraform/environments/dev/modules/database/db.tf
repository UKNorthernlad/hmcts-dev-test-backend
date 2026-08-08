resource "azurerm_postgresql_flexible_server" "dbserver" {
  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name   = var.sku_name
  version    = var.postgresql_version
  storage_mb = var.storage_mb

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  zone = var.zone

  authentication {
    password_auth_enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "azurerm_postgresql_flexible_server_database" "appdb" {
  name      = var.app_db_name
  server_id = azurerm_postgresql_flexible_server.dbserver.id

  charset   = var.app_db_charset
  collation = var.app_db_collation

  lifecycle {
    prevent_destroy = true
  }
}

output "server_id" {
  value = azurerm_postgresql_flexible_server.dbserver.id
}

output "server_fqdn" {
  value = azurerm_postgresql_flexible_server.dbserver.fqdn
}

output "app_db_name" {
  value = azurerm_postgresql_flexible_server_database.appdb.name
}