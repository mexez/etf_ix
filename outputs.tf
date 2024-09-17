output "storage_account_primary_connection_string" {
  value = azurerm_storage_account.eoanblb01.primary_connection_string
}

output "storage_account_secondary_connection_string" {
  value = azurerm_storage_account.eoanfundtestdata.primary_connection_string
}

output "sql_server_fqdn" {
  value = azurerm_sql_server.sql_server.fully_qualified_domain_name
}
