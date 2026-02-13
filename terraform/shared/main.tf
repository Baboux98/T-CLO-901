# ============================================
# SHARED INFRASTRUCTURE - Main Configuration
# ============================================
# Creates a shared Azure MySQL Flexible Server used by
# BOTH PaaS (App Service) and IaaS (VM) in the same environment.
#
# WHY SHARED?
# - Cost saving: 1 MySQL server instead of 2
# - Staging: PaaS app + IaaS VM both connect here
# - Prod:    PaaS app + IaaS VM both connect here
# - Dev:     Does NOT use this (dev uses in-app/container DB)

locals {
  is_dev = var.environment == "dev"
  env    = terraform.workspace
}

locals {
  _guard = var.environment == local.env ? true : file("ERROR_WRONG_ENV")
}

# ============================================
# RESOURCE GROUP
# ============================================
resource "azurerm_resource_group" "shared" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment    = var.environment
    Project        = "T-CLO-901"
    ManagedBy      = "Terraform"
    DeploymentType = "Shared"
    Purpose        = "Shared MySQL for PaaS + IaaS"
  }
}

# ============================================
# MYSQL FLEXIBLE SERVER
# ============================================
# This single MySQL server is shared between PaaS and IaaS
resource "azurerm_mysql_flexible_server" "shared" {
  name                   = "mysql-${var.app_name}-shared-${var.environment}"
  resource_group_name    = azurerm_resource_group.shared.name
  location               = azurerm_resource_group.shared.location
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  sku_name               = var.mysql_sku
  version                = "8.0.21"

  storage {
    size_gb = 20 # 20 GB minimum
  }

  backup_retention_days = 7

  tags = {
    Environment = var.environment
    SharedBy    = "PaaS + IaaS"
  }
}

# ============================================
# MYSQL DATABASE
# ============================================
resource "azurerm_mysql_flexible_database" "shared" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.shared.name
  server_name         = azurerm_mysql_flexible_server.shared.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# ============================================
# FIREWALL RULES
# ============================================

# Allow Azure services (App Service) to connect
resource "azurerm_mysql_flexible_server_firewall_rule" "azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.shared.name
  server_name         = azurerm_mysql_flexible_server.shared.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Allow all IPs (for IaaS VM + dev machine access)
# NOTE: In a real production environment, restrict to specific IPs!
resource "azurerm_mysql_flexible_server_firewall_rule" "allow_all" {
  name                = "AllowAll-ForLearning"
  resource_group_name = azurerm_resource_group.shared.name
  server_name         = azurerm_mysql_flexible_server.shared.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
