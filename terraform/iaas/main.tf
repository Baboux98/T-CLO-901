# ============================================
# IAAS MAIN - Multi-Environment Configuration
# ============================================
# Environment behavior:
#   dev     → VM + Docker Compose (app + MySQL containers)
#   staging → VM + Docker app only + shared external Azure MySQL
#   prod    → VM + Docker app only + shared external Azure MySQL
#
# Usage:
#   terraform workspace select dev
#   terraform apply -var-file=environments/dev.tfvars

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
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location

  tags = {
    Environment    = var.environment
    Project        = "T-CLO-901"
    ManagedBy      = "Terraform"
    DeploymentType = "IaaS"
  }
}

# ============================================
# VIRTUAL NETWORK
# ============================================
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.app_name}-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = var.resource_group_name
  }
}

# ============================================
# SUBNET
# ============================================
resource "azurerm_subnet" "main" {
  name                 = "subnet-${var.app_name}-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ============================================
# PUBLIC IP ADDRESS
# ============================================
resource "azurerm_public_ip" "main" {
  name                = "pip-${var.app_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.resource_group_name
  }
}

# ============================================
# NETWORK SECURITY GROUP (FIREWALL)
# ============================================
resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.app_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # Allow SSH (port 22)
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTP (port 80)
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTPS (port 443)
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.resource_group_name
  }
}

# ============================================
# NETWORK INTERFACE
# ============================================
resource "azurerm_network_interface" "main" {
  name                = "nic-${var.app_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = {
    Environment = var.resource_group_name
  }
}

# Associate NSG with Network Interface
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# ============================================
# VIRTUAL MACHINE
# ============================================
resource "azurerm_linux_virtual_machine" "main" {
  name                = "vm-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username


  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.ssh_public_key_path)
  }

  disable_password_authentication = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  tags = {
    Environment    = var.resource_group_name
    Project        = "T-CLO-901-IaaS"
    ManagedBy      = "Terraform"
    DeploymentType = "IaaS"
  }
}

# ============================================
# GENERATE ANSIBLE INVENTORY
# ============================================
# Automatically creates the Ansible inventory file
# with the VM's IP and all variables Ansible needs.
# The key variable is 'use_external_db':
#   false (dev)          → Ansible deploys MySQL in Docker
#   true  (staging/prod) → Ansible only deploys app, uses external MySQL
resource "local_file" "ansible_inventory" {
  content = <<-EOF
    [webservers]
    ${azurerm_public_ip.main.ip_address} ansible_user=${var.vm_admin_username} ansible_ssh_private_key_file=C:/Users/DELL/.ssh/id_ed25519.pub

    [webservers:vars]
    app_name=${var.app_name}-${var.environment}
    app_key=${var.app_key}
    environment=${var.environment}
    github_username=${var.github_username}
    github_token=${var.github_token}
    db_name=${var.db_name}
    db_username=${var.db_admin_username}
    db_password=${var.db_admin_password}
    use_external_db=${var.use_external_db}
    db_host=${var.use_external_db ? var.external_db_host : "mysql"}
  EOF

  filename = "../../ansible/inventory/${var.environment}/hosts.ini"
}
