# This file tells Terraform which cloud provider to use (Azure)

# Specify the required Terraform version and providers
terraform {
  required_version = "= 1.14.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.59.0" # Use stable version 4.x of the Azure provider
    }
  }
}

# Configure the Azure provider
provider "azurerm" {
  features {} # Required block, can be empty for basic usage

  subscription_id = var.subscription_id # From terraform.tfvars

  # Terraform will use Azure CLI authentication by default
  # Make sure you run 'az login' before using Terraform
}
