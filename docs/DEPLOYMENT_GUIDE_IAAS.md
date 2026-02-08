# 🚀 Quick Start

## Prerequisites

- Azure Student Subscription (or any Azure account)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Terraform](https://www.terraform.io/downloads) installed
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed (for IaaS)
- Git installed

## 1. Clone and Setup

```bash
git clone <your-repo-url>
cd T-CLO-901
```

## 2. Login to Azure

```powershell
az login
az account show  # Verify correct subscription
```

## 3. Deploy PaaS (Easier, start here!)

```powershell
cd terraform/paas
terraform init
terraform plan
terraform apply
```

See [terraform/paas/README.md](terraform/paas/README.md) for detailed steps.

## 4. Deploy IaaS

```powershell
cd terraform/iaas
terraform init
terraform apply

# Then configure with Ansible
cd ../../ansible
ansible-playbook -i inventory/hosts.ini playbook.yml
```

See [terraform/iaas/README.md](terraform/iaas/README.md) for detailed steps.
