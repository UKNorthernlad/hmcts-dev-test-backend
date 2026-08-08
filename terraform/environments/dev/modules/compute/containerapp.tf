
###############
# Logging
###############
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "cases-workspace"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

###############
# Container App Environment
###############
resource "azurerm_container_app_environment" "cae" {
  name                       = "cases-environment"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
}

###############
# Container App
###############
resource "azurerm_container_app" "ca" {
  name                         = var.name
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = var.name
      image  = var.container_image
      cpu    = 1
      memory = "1Gi"

      env {
        name  = "DB_HOST"
        value = "localhost"
      }

      env {
        name  = "DB_PORT"
        value = 5432
      }

      env {
        name  = "DB_NAME"
        value = "localhost"
      }

      env {
        name  = "DB_OPTIONS"
        value = "localhost"
      }

      env {
        name  = "DB_USER_NAME"
        value = "localhost"
      }

      env {
        name  = "DB_PASSWORD"
        value = "localhost"
      }
    }
  }
}

