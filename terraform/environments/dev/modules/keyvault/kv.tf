provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "kv" {
  name                       = var.kvname
  location                   = var.location
  resource_group_name        = var.resource_group_name
  rbac_authorization_enabled = false
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

#resource "azurerm_key_vault_secret" "secretname" {
#  name         = "secretname"
#  value        = "seceretvalue"
#  key_vault_id = azurerm_key_vault.kv.id
#}