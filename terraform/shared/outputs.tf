# ============================================
# SHARED INFRASTRUCTURE - Outputs
# ============================================
# These outputs are needed by PaaS and IaaS configs.
# After running: terraform output mysql_server_fqdn
# Copy the value into paas/environments/staging.tfvars and iaas/environments/staging.tfvars

output "mysql_server_fqdn" {
  description = "MySQL server FQDN - copy this into PaaS and IaaS tfvars as 'external_db_host'"
  value       = azurerm_mysql_flexible_server.shared.fqdn
}

output "mysql_database_name" {
  description = "MySQL database name"
  value       = azurerm_mysql_flexible_database.shared.name
}

output "mysql_admin_username" {
  description = "MySQL admin username"
  value       = var.db_admin_username
}

output "resource_group_name" {
  description = "Shared resource group name"
  value       = azurerm_resource_group.shared.name
}

output "external_db_host" {
  description = "External DB host for PaaS and IaaS to connect to"
  value       = azurerm_mysql_flexible_server.shared.fqdn
}

# Helper: shows what to put in PaaS/IaaS tfvars
output "next_steps" {
  description = "Instructions for connecting PaaS and IaaS"
  value       = <<-EOF
    ✅ Shared MySQL deployed!

    Copy this into your PaaS and IaaS ${var.environment}.tfvars:
      external_db_host = "${azurerm_mysql_flexible_server.shared.fqdn}"

    Then deploy PaaS and IaaS:
      cd ../paas && terraform workspace select ${var.environment} && terraform apply -var-file=environments/${var.environment}.tfvars
      cd ../iaas && terraform workspace select ${var.environment} && terraform apply -var-file=environments/${var.environment}.tfvars
  EOF
}
