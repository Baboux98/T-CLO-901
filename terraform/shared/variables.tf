# ============================================
# SHARED INFRASTRUCTURE - Variables
# ============================================
# These variables configure the shared MySQL database
# used by both PaaS and IaaS in staging/prod environments.

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
  description = "Name of the shared resource group"
  type        = string
}

variable "app_name" {
  description = "Base name for the application"
  type        = string
}

variable "environment" {
  description = "Environment name (staging, prod)"
  type        = string

  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "Shared resources are only for staging and prod. Dev uses in-app databases."
  }
}

# ============================================
# DATABASE CONFIGURATION
# ============================================

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

variable "mysql_sku" {
  description = "MySQL Flexible Server SKU"
  type        = string
  default     = "B_Standard_B1ms"
  # B_Standard_B1ms = 1 vCPU, 2 GB RAM (~$13/month)
  # This is the cheapest SKU that works well
}

variable "external_db_host" {
  description = "External DB host for PaaS and IaaS to connect to"
  type        = string
}