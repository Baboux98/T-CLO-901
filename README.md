# TerraCloud - Azure Deployment Project (T-CLO-901)

> Deploying an application on Azure using both IaaS and PaaS approaches

## 📋 Project Overview

This project demonstrates the deployment of a web application (Laravel ) on Microsoft Azure using two different cloud computing models:

1. **IaaS (Infrastructure as a Service)** - Using Azure Virtual Machines
2. **PaaS (Platform as a Service)** - Using Azure App Service

The goal is to compare performance, cost, complexity, and management overhead between these two approaches.

## 🎯 Objectives

- ✅ Deploy Laravel application using **IaaS** (VM + Docker + Ansible)
- ✅ Deploy Laravel application using **PaaS** (Azure App Service)
- 📊 Conduct **performance testing** and comparison (Apache Bench)
- 💰 Perform **cost analysis**
- 📝 Document architecture, deployment process, and findings
- 🔄 Create **reproducible** infrastructure as code (Terraform)
- 🤖 Automate deployment and configuration (Git Action, Ansible for IaaS)

## 📂 Project Structure

```
T-CLO-901/
├── README.md                          # This file - main project documentation
├── .gitignore                         # Git ignore rules
├── .gitattributes                     # Line ending configuration
│
├── webapp/                            # Laravel application
│   ├── Dockerfile                     # Container definition
│   ├── docker-compose.yaml            # Local development setup
│   ├── app/                           # Laravel application code
│   └── (all Laravel files...)
│
├── terraform/                         # Infrastructure as Code
│   ├── iaas/                          # IaaS deployment
│   │   ├── main.tf                    # VM, network, security resources
│   │   ├── variables.tf               # Input variables
│   │   ├── outputs.tf                 # Output values (IP, SSH info)
│   │   ├── providers.tf               # Azure provider configuration
│   │   ├── terraform.tfvars           # Your actual values (not in Git)
│   │   └── README.md                  # IaaS deployment guide
│   │
│   └── paas/                          # PaaS deployment
│       ├── main.tf                    # App Service, MySQL resources
│       ├── variables.tf               # Input variables
│       ├── outputs.tf                 # Output values (URLs, connection info)
│       ├── providers.tf               # Azure provider configuration
│       ├── terraform.tfvars           # Your actual values (not in Git)
│       └── README.md                  # PaaS deployment guide
│
├── ansible/                           # Configuration management (IaaS only)
│   ├── playbook.yml                   # Main Ansible playbook
│   ├── inventory/
│   │   └── hosts.ini                  # Created by Terraform
│   ├── roles/                         # Organized by roles
│   │   ├── docker/                    # Install & configure Docker
│   │   └── app/                       # Deploy Laravel application
│   └── README.md                      # Ansible usage guide
│
├── scripts/                           # Utility scripts
│   ├── deploy-iaas.sh                 # Quick IaaS deployment
│   ├── deploy-paas.sh                 # Quick PaaS deployment
│   ├── destroy-iaas.sh                # Cleanup IaaS resources
│   ├── destroy-paas.sh                # Cleanup PaaS resources
│   └── stress-test.sh                 # Apache Bench testing
│
├── docs/                              # Detailed documentation
│   ├── ARCHITECTURE.md                # Architecture diagrams & explanations
│   ├── COST_COMPARISON.md             # Cost analysis & optimization
│   ├── PERFORMANCE_TESTS.md           # Stress test methodology & results
│   ├── DEPLOYMENT_GUIDE_IAAS.md       # Step-by-step IaaS guide
│   └── DEPLOYMENT_GUIDE_PAAS.md       # Step-by-step PaaS guide
│
└── tests/                             # Test results & evidence
    ├── stress-tests/
    │   ├── iaas-results.txt           # IaaS performance data
    │   └── paas-results.txt           # PaaS performance data
    └── screenshots/
        ├── iaas-running.png           # IaaS deployment proof
        └── paas-running.png           # PaaS deployment proof
```

## 📝 Documentation

Detailed documentation is available in the `docs/` folder:

- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - Detailed architecture diagrams and explanations
- **[DEPLOYMENT_GUIDE_IAAS.md](docs/DEPLOYMENT_GUIDE_IAAS.md)** - Step-by-step IaaS deployment
- **[DEPLOYMENT_GUIDE_PAAS.md](docs/DEPLOYMENT_GUIDE_PAAS.md)** - Step-by-step PaaS deployment
- **[COST_COMPARISON.md](docs/COST_COMPARISON.md)** - Detailed cost analysis
- **[PERFORMANCE_TESTS.md](docs/PERFORMANCE_TESTS.md)** - Testing methodology and results

## 🛠️ Technologies Used

- **Cloud Provider:** Microsoft Azure
- **IaC (Infrastructure as Code):** Terraform
- **Configuration Management:** Ansible
- **Containerization:** Docker, Docker Compose
- **Application:** Laravel (PHP)
- **Database:** MySQL
- **Web Server:** Nginx
- **Testing:** Apache Bench (ab)
- **Version Control:** Git/GitHub

## 🎓 Learning Outcomes

By completing this project, you will learn:

- ✅ Infrastructure as Code with Terraform
- ✅ Configuration management with Ansible
- ✅ Docker containerization
- ✅ Azure cloud services (both IaaS and PaaS)
- ✅ Performance testing and benchmarking
- ✅ Cost analysis and optimization
- ✅ DevOps best practices
- ✅ Cloud architecture design

## ⚠️ Important Notes

### Security

- **Never commit secrets to Git** (`.gitignore` protects you)
- Use strong passwords for databases
- Restrict firewall rules in production
- Keep Azure credentials secure

### Resource Management

- **Constraint:** Only 1 VM and 1 App Service allowed
- Always destroy resources when done testing
- Monitor your Azure credit balance
- Use cost alerts

### Reproducibility

All infrastructure is defined as code:

- Anyone with Azure access can deploy using your Terraform code
- Ansible ensures consistent VM configuration
- Docker ensures consistent application environment

## 📄 License

This project is for educational purposes.

## 📞 Support

If you encounter issues:

- Check the README in each folder (terraform/iaas, terraform/paas, ansible)
- Review Azure documentation
- Check Terraform/Ansible logs
- Ask your instructor or peers

---

**Ready to deploy?** Start with the [PaaS deployment guide](terraform/paas/README.md)! It's simpler and a great way to learn.

**Project Status:** 🚧 In Development

## Last Updated: February 8, 2026

## NEXT STEPS

1. ✅ Application analysis complete
2. ⏭️ Create Terraform files for IaaS
3. ⏭️ Create Terraform files for PaaS
4. ⏭️ Create Ansible playbooks
5. ⏭️ Deploy and test both infrastructures
6. ⏭️ Run stress tests
7. ⏭️ Compare costs
8. ⏭️ Write deployment guides
9. ⏭️ Document everything
