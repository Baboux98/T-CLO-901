# ============================================
# PAAS VARIABLES - Multi-Environment
# ============================================
# These variables support 3 environments:
#   dev     → F1 (free) + SQLite (in-app database)
#   staging → B1 + shared external Azure MySQL
#   prod    → B1 + shared external Azure MySQL

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "app_name" {
  description = "Base name for the application"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# ============================================
# APP SERVICE CONFIGURATION
# ============================================

variable "app_service_sku" {
  description = "App Service Plan SKU (F1=Free, B1=Basic)"
  type        = string
  # F1 = Free (dev)
  # B1 = Basic ~$13/month (staging/prod)
}

# ============================================
# DATABASE CONFIGURATION
# ============================================
# For dev: these are ignored (SQLite is used)
# For staging/prod: external_db_host points to the shared MySQL

variable "use_external_db" {
  description = "Whether to use external Azure MySQL (true for staging/prod, false for dev)"
  type        = bool
  default     = false
}

variable "external_db_host" {
  description = "FQDN of the shared Azure MySQL server (from shared terraform output)"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "MySQL database name"
  type        = string
  default     = ""
}

variable "db_admin_username" {
  description = "MySQL administrator username"
  type        = string
  default     = ""
}

variable "db_admin_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
  default     = ""
}

# ============================================
# APPLICATION CONFIGURATION
# ============================================

variable "app_key" {
  description = "Laravel APP_KEY"
  type        = string
  sensitive   = true
}

# GitHub Container Registry credentials
variable "github_username" {
  description = "GitHub username"
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token with packages:read"
  type        = string
  sensitive   = true
}
