# ============================================
# IAAS OUTPUTS - Multi-Environment
# ============================================

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.main.ip_address
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.vm_admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "app_url" {
  description = "URL to access the Laravel application"
  value       = "http://${azurerm_public_ip.main.ip_address}"
}

output "ansible_command" {
  description = "Command to run Ansible playbook"
  value       = "cd ../../ansible && ansible-playbook -i inventory/${var.environment}/hosts.ini playbook.yml"
}

output "vm_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure region"
  value       = azurerm_resource_group.main.location
}

output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "db_type" {
  description = "Database type used"
  value       = var.use_external_db ? "External Azure MySQL (shared)" : "MySQL in Docker container"
}

output "deployment_summary" {
  description = "Summary of what was deployed"
  value       = <<-EOF
    ✅ IaaS ${var.environment} deployed!
      - VM:       ${azurerm_linux_virtual_machine.main.name} (${var.vm_size})
      - IP:       ${azurerm_public_ip.main.ip_address}
      - SSH:      ssh ${var.vm_admin_username}@${azurerm_public_ip.main.ip_address}
      - App:      http://${azurerm_public_ip.main.ip_address}
      - Database: ${var.use_external_db ? "External MySQL (${var.external_db_host})" : "MySQL in Docker container"}

    Next: Run Ansible to configure the VM:
      cd ../../ansible && ansible-playbook -i inventory/${var.environment}/hosts.ini playbook.yml
  EOF
}
