# 🏗️ Architecture

## IaaS Architecture

```
Internet → Azure VM (Linux)
           ├── Docker Engine
           │   └── Laravel Container
           │       └── MySQL Container
           └── Configured by Ansible
```

**Components:**

- Azure Virtual Machine (Linux)
- Docker & Docker Compose
- Laravel application in container
- MySQL database in container
- Nginx web server
- Automated with Ansible

## PaaS Architecture

```
Internet → Azure App Service (Linux)
           └── Laravel App
               ↓
           Azure Database for MySQL (Flexible Server)
```

**Components:**

- Azure App Service (Linux)
- Azure Database for MySQL (Managed)
- Built-in scaling and load balancing
- Managed by Azure
