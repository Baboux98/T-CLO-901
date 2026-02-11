# ============================================
# IAAS VARIABLES - Multi-Environment
# ============================================
# These variables support 3 environments:
#   dev     → VM B1ms + Docker Compose (app + MySQL containers)
#   staging → VM B1ms + Docker app only + shared external Azure MySQL
#   prod    → VM B1ms + Docker app only + shared external Azure MySQL

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
# VM CONFIGURATION
# ============================================

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1ms" # 1 vCPU, 2 GB RAM (~$15/month)
}

variable "vm_admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# ============================================
# DATABASE CONFIGURATION
# ============================================
# Dev: MySQL runs in Docker container (these creds are for the container)
# Staging/Prod: these creds connect to the shared external Azure MySQL

variable "use_external_db" {
  description = "Use external Azure MySQL (true for staging/prod, false for dev)"
  type        = bool
  default     = false
}

variable "external_db_host" {
  description = "FQDN of the shared Azure MySQL (from shared terraform output)"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "MySQL database name"
  type        = string
}

variable "db_admin_username" {
  description = "MySQL administrator username"
  type        = string
}

variable "db_admin_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
}

# ============================================
# APPLICATION CONFIGURATION
# ============================================

variable "app_key" {
  description = "Laravel APP_KEY"
  type        = string
  sensitive   = true
}

variable "github_username" {
  description = "GitHub username"
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}
