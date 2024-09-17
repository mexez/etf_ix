resource "azurerm_resource_group" "rg" {
  name     = "eoan-rg"
  location = "Canada Central"
}

resource "azurerm_storage_account" "eoanblb01" {
  name                     = "eoanblb01i"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_storage_account" "eoanfundtestdata" {
  name                     = "eoanfundtestdatai"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_key_vault" "kv" {
  name                        = "EOAN-Fund-KVi"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  #soft_delete_enabled         = true
  purge_protection_enabled    = true

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Backup",
      "Restore",
      "Recover",
      "Purge"
    ]
  }
}

resource "azurerm_data_factory" "adf_prod" {
  name                = "EOAN-ADF-PROD"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_data_factory" "adf_dev" {
  name                = "EOAN-ADF-DEV"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_sql_server" "sql_server" {
  name                         = "eoan-fund-sql-server"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_sql_database" "sql_db_prod" {
  name                = "eoan-fund-db-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sql_server.name
  edition             = "Standard"
  requested_service_objective_name = "S0"
}

resource "azurerm_sql_database" "sql_db_dev" {
  name                = "eoan-fund-db-dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sql_server.name
  edition             = "Standard"
  requested_service_objective_name = "S0"
}

# resource "azurerm_logic_app_workflow" "logic_app" {
#   name                = var.logic_app_name
#   location            = var.logic_app_location
#   resource_group_name = azurerm_resource_group.rg.name

#   definition = <<DEFINITION
# {
#   "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
#   "actions": {
#     "HTTP_Action": {
#       "inputs": {
#         "headers": {
#           "Content-Type": "application/json"
#         },
#         "method": "POST",
#         "uri": "https://example.com/api",
#         "body": {
#           "storageAccountName": "${azurerm_storage_account.eoanblb01.name}",
#           "connectionString": "${azurerm_storage_account.eoanblb01.primary_connection_string}"
#         }
#       },
#       "runAfter": {
#         "manual": [
#           "Succeeded"
#         ]
#       },
#       "type": "Http"
#     }
#   },
#   "contentVersion": "1.0.0.0",
#   "outputs": {},
#   "parameters": {},
#   "triggers": {
#     "manual": {
#       "type": "Request",
#       "kind": "Http",
#       "schema": {
#         "properties": {
#           "name": {
#             "type": "string"
#           }
#         },
#         "type": "object"
#       }
#     }
#   }
# }
# DEFINITION
# }

