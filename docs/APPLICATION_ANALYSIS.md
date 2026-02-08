# TERRACLOUD - APPLICATION ANALYSIS

**Sample App - Laravel Counter Application**

---

## 1. FUNCTIONAL ANALYSIS (User Perspective) 👤

### What the Application Does:

The application is a **simple web-based counter** that allows users to:

1. **View Current Count**: Displays the total count on the homepage
2. **Increment Counter**: Click a "+1" button to add 1 to the total count
3. **Real-time Updates**: The counter updates without page refresh using AJAX

### User Interactions:

- **Homepage (`/`)**: Displays "Hello world sample app" with current counter value
- **Button Click**: Clicking "+1" button sends API request and updates display
- **API Endpoints**:
  - `GET /api/counter/add` - Adds 1 to counter and returns new total
  - `GET /api/counter/count` - Returns current counter value

### User Flow:

```
User visits page → Sees current count → Clicks "+1" → Counter increments → Display updates
```

### Business Logic:

- Each click creates a new database record with `count = 1`
- Total is calculated by summing all counter records in database
- Simple, stateless counter that persists across sessions

---

## 2. APPLICATIVE ANALYSIS (Software Stack) 💻

### Technology Stack:

#### **Backend Framework:**

- **Laravel 8.75** (PHP Framework)
- **PHP 8.2.8** (Runtime)
- **Composer** (Dependency Manager)

#### **Database:**

- **MySQL 8.0** (Relational Database)
  - Port: 3306
  - Database: `app_database`
  - Tables: `counters` (main), `users`, `password_resets`, `failed_jobs`, `personal_access_tokens`

#### **Web Server:**

- **Apache 2.4** (Built into PHP Docker image)
- **Document Root**: `/var/www/html/public`
- **Rewrite Module**: Enabled for Laravel routing

#### **Frontend:**

- **Blade Templates** (Laravel's templating engine)
- **jQuery 3.7.0** (For AJAX requests)
- **Plain HTML/CSS** (No framework)

#### **Containerization:**

- **Docker** (Application containerization)
- **Docker Compose** (Multi-container orchestration)
- **Traefik v3.0** (Reverse proxy & load balancer - optional)

### Dependencies (from composer.json):

```json
{
  "php": "^7.3|^8.0|^8.2",
  "laravel/framework": "^8.75",
  "laravel/sanctum": "^2.11",
  "guzzlehttp/guzzle": "^7.0.1",
  "fruitcake/laravel-cors": "^2.0"
}
```

### Database Schema:

```sql
-- counters table
CREATE TABLE counters (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    count BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);
```

### Environment Variables Required:

```env
APP_DEBUG=true
APP_ENV=dev
APP_KEY=base64:DJYTvaRkEZ/YcQsX3TMpB0iCjgme2rhlIOus9A1hnj4=
DB_CONNECTION=mysql
DB_HOST=<database_host>
DB_PORT=3306
DB_DATABASE=app_database
DB_USERNAME=app_user
DB_PASSWORD=app_password
```

### Ports Used:

- **80** - HTTP (Application)
- **3306** - MySQL (Database)
- **8081** - Alternative HTTP port (in docker-compose)
- **8082** - Prometheus metrics (Traefik)

---

## 3. INFRASTRUCTURE ANALYSIS (Servers & Network) 🏗️

### 3.1 IaaS Deployment Architecture

#### **Compute Resources:**

**Virtual Machine Specifications:**

- **Minimum VM Size**: Standard_B1s (1 vCPU, 1 GB RAM)
  - Cost: ~$7.59/month
  - Good for: Development/Testing
- **Recommended VM Size**: Standard_B2s (2 vCPU, 4 GB RAM)
  - Cost: ~$30.37/month
  - Good for: Production with moderate load
- **Operating System**: Ubuntu 22.04 LTS or Ubuntu 24.04 LTS
  - Reason: Free, well-supported, Docker-friendly

#### **Network Configuration:**

**Virtual Network (VNet):**

- Address Space: `10.0.0.0/16`
- Subnet: `10.0.1.0/24` (VM subnet)

**Network Security Group (NSG):**

```
Inbound Rules:
- Port 80 (HTTP) - Allow from Internet
- Port 443 (HTTPS) - Allow from Internet (if SSL)
- Port 22 (SSH) - Allow from your IP only
- Port 3306 (MySQL) - Deny from Internet (internal only)

Outbound Rules:
- Allow all (for updates, package downloads)
```

**Public IP:**

- Static IP (for consistent access)
- Standard SKU

#### **Storage:**

- **OS Disk**: 30 GB Premium SSD (P4)
  - Cost: ~$4.61/month
- **Data Disk** (optional): For MySQL data persistence
  - 32 GB Premium SSD (P6)
  - Cost: ~$7.38/month

#### **Components Needed:**

1. **VM** - Runs Docker containers
2. **MySQL Container** - Database
3. **App Container** - Laravel application
4. **Traefik Container** (optional) - Reverse proxy

**Total IaaS Monthly Cost (Estimated):**

- VM (B1s): $7.59
- OS Disk: $4.61
- Public IP: $3.65
- **Total: ~$15.85/month** (B1s)
- **Total: ~$46.01/month** (B2s recommended)

---

### 3.2 PaaS Deployment Architecture

#### **Azure Services Required:**

**1. Azure App Service (Web App):**

- **Service Plan Options:**

  **Free Tier (F1):**
  - 1 GB RAM, 60 CPU minutes/day
  - 1 GB storage
  - Cost: $0/month
  - Limitations: No always-on, no custom domains

  **Basic B1:**
  - 1.75 GB RAM, 1 vCPU
  - 10 GB storage
  - Cost: ~$13.14/month
  - Good for: Small production workloads

  **Standard S1** (Recommended):
  - 1.75 GB RAM, 1 vCPU
  - 50 GB storage
  - Auto-scaling, custom domains, SSL
  - Cost: ~$69.35/month

**2. Azure Database for MySQL:**

- **Basic Tier:**
  - 1 vCore, 2 GB RAM
  - 5 GB - 1 TB storage
  - Cost: ~$26.28/month (B1ms)
- **General Purpose Tier:**
  - 2 vCores, 4 GB RAM
  - Cost: ~$123.36/month

**Alternative: MySQL In-App** (Shared with Web App)

- Free for F1/B1 tiers
- Limited to 1 GB storage
- Not recommended for production

**Total PaaS Monthly Cost (Estimated):**

- **Option 1 (Budget)**: Free Web App + MySQL In-App = $0/month
- **Option 2 (Basic)**: B1 Web App + Basic MySQL = ~$39.42/month
- **Option 3 (Production)**: S1 Web App + Basic MySQL = ~$95.63/month

---

### 3.3 Network Architecture

#### **IaaS Network Diagram:**

```
Internet
    ↓
Azure Load Balancer (optional)
    ↓
Public IP → NSG → VM (Ubuntu)
                   ├── Docker: App Container (Port 80)
                   ├── Docker: MySQL Container (Port 3306)
                   └── Docker: Traefik (optional)
```

#### **PaaS Network Diagram:**

```
Internet
    ↓
Azure Front Door / CDN (optional)
    ↓
App Service (Web App)
    ↓
Azure Database for MySQL
```

---

## 4. OPS ANALYSIS (Monitoring, Backups, Logging) 📊

### 4.1 Monitoring Strategy

#### **IaaS Monitoring:**

**Azure Monitor Metrics:**

- VM CPU utilization (alert if > 80%)
- VM memory usage (alert if > 85%)
- Disk I/O performance
- Network in/out
- **Cost**: Free (basic metrics)

**Application Insights:**

- Response times
- Failed requests (5xx errors)
- Dependency tracking (MySQL queries)
- **Cost**: $2.88/GB ingested

**Container Monitoring:**

- Docker stats (CPU, memory per container)
- Container health checks
- **Tool**: Docker stats, cAdvisor, or Prometheus

**Database Monitoring:**

- MySQL connection count
- Slow query log
- Database size growth
- **Tool**: MySQL Workbench, phpMyAdmin

**Custom Health Checks:**

```bash
# Application health
curl http://your-vm-ip/

# API health
curl http://your-vm-ip/api/counter/count

# Database connectivity test
docker exec mysql mysql -u app_user -p app_database -e "SELECT 1"
```

#### **PaaS Monitoring:**

**Built-in App Service Monitoring:**

- HTTP requests/responses
- Response time
- CPU time
- Memory usage
- HTTP 5xx errors
- **Cost**: Included

**Azure Database for MySQL Monitoring:**

- Active connections
- CPU percent
- Storage percent
- IO percent
- Replication lag (if using replica)
- **Cost**: Included

**Application Insights** (Recommended):

- End-to-end transaction tracing
- Custom events
- Real user monitoring
- **Cost**: $2.88/GB

### 4.2 Logging Strategy

#### **IaaS Logging:**

**Application Logs:**

- **Location**: `/var/www/html/storage/logs/laravel.log`
- **Retention**: 7-30 days
- **Tool**: Laravel built-in logging

**Web Server Logs:**

- **Apache Access**: `/var/log/apache2/access.log`
- **Apache Error**: `/var/log/apache2/error.log`
- **Retention**: 14 days (rotate)

**System Logs:**

- **Syslog**: `/var/log/syslog`
- **Auth log**: `/var/log/auth.log`

**Database Logs:**

- **Error log**: Docker MySQL container logs
- **Slow query log**: Enable for queries > 2s

**Centralized Logging** (Optional):

- **Azure Log Analytics Workspace**
  - Collect all logs in one place
  - Query with KQL
  - **Cost**: $2.88/GB ingested
- **Alternative**: ELK Stack (Elasticsearch, Logstash, Kibana)
  - Self-hosted on VM
  - Higher resource usage

#### **PaaS Logging:**

**App Service Logs:**

- **Application logging**: Enable via Azure Portal
- **Web server logging**: Enabled by default
- **Detailed error messages**: For debugging
- **Failed request tracing**: For troubleshooting

**Storage Options:**

- Blob Storage (long-term retention)
- File System (short-term, 7 days max)
- Log Analytics Workspace (queryable)

**Database Logs:**

- Audit logs (who accessed what)
- Slow query logs
- Error logs
- **Retention**: Configurable (7-90 days)

### 4.3 Backup Strategy

#### **IaaS Backups:**

**VM Snapshots:**

- **Azure Backup**:
  - Automated daily backups
  - Retention: 7-30 days
  - **Cost**: $10-$50/month (depending on size)

**Database Backups:**

- **MySQL Automated Dumps**:
  ```bash
  # Daily cron job
  mysqldump -u app_user -p app_database > backup_$(date +%Y%m%d).sql
  ```

  - Store in Azure Blob Storage
  - Retention: 30 days
- **Docker Volume Backups**:
  ```bash
  docker run --rm --volumes-from mysql \
    -v $(pwd):/backup \
    ubuntu tar cvf /backup/db_backup.tar /var/lib/mysql
  ```

**Backup Schedule:**

- **Daily**: Database dumps (automated)
- **Weekly**: VM snapshots
- **Monthly**: Full backup with offsite storage

#### **PaaS Backups:**

**App Service Backups:**

- **Automatic backups** (Standard tier and above):
  - App content
  - Configuration
  - Database connection strings
  - **Schedule**: Daily or custom
  - **Retention**: Up to 30 days

**Azure Database for MySQL Backups:**

- **Automated backups**:
  - Full backup: Weekly
  - Differential: Daily
  - Transaction log: Every 5 minutes
  - **Retention**: 7-35 days (configurable)
  - **Point-in-time restore**: Any time within retention
  - **Cost**: Included in database cost

**Geo-Redundant Backup** (Recommended):

- Store backups in different Azure region
- Protection against regional failures
- **Cost**: Additional $5-10/month

### 4.4 Alerting & Incident Response

#### **Critical Alerts:**

**IaaS Alerts:**

1. VM CPU > 85% for 10 minutes → Email + SMS
2. Disk space > 90% → Email
3. MySQL connection failures → Email
4. HTTP 5xx errors > 10/minute → Email + SMS
5. VM is stopped/deallocated → Email + SMS

**PaaS Alerts:**

1. App Service CPU > 80% for 10 minutes → Email
2. HTTP 5xx errors > 10/minute → Email + SMS
3. Database CPU > 80% → Email
4. Database storage > 85% → Email
5. Average response time > 3s → Email

#### **Alert Channels:**

- **Email**: To team members
- **SMS**: For critical alerts
- **Slack/Teams webhook**: For team notifications
- **Azure Monitor Action Groups**: Configured per alert

#### **Incident Response Plan:**

1. Alert triggers
2. On-call engineer receives notification
3. Check Azure Portal/Monitoring dashboard
4. Investigate logs (Application Insights, Log Analytics)
5. Take corrective action:
   - Scale up resources
   - Restart services
   - Rollback deployment
6. Document incident
7. Post-mortem analysis

### 4.5 Security & Compliance

#### **Security Measures:**

**IaaS Security:**

- NSG rules (least privilege)
- SSH key authentication (no passwords)
- Regular OS updates (`apt update && apt upgrade`)
- Firewall (ufw) enabled
- Fail2ban for SSH protection
- SSL/TLS certificates (Let's Encrypt)
- Secrets in Azure Key Vault (not in code)

**PaaS Security:**

- Managed identities (no passwords)
- SSL/TLS enforced
- Azure SQL firewall rules
- VNET integration (private endpoints)
- App Service authentication (Azure AD)
- Secrets in Azure Key Vault

**Application Security:**

- Environment variables for secrets (no hardcoding)
- CSRF protection (Laravel built-in)
- SQL injection prevention (Eloquent ORM)
- Input validation
- Rate limiting for API endpoints

#### **Compliance:**

- **GDPR**: If storing user data
- **Data retention policies**: Define how long to keep logs/backups
- **Access control**: RBAC in Azure
- **Audit trails**: Enable Azure Activity Logs

---

## 5. DEPLOYMENT REQUIREMENTS SUMMARY

### 5.1 IaaS Requirements

**Terraform Resources Needed:**

```
- azurerm_resource_group
- azurerm_virtual_network
- azurerm_subnet
- azurerm_network_security_group
- azurerm_network_interface
- azurerm_public_ip
- azurerm_linux_virtual_machine
- azurerm_managed_disk (optional)
```

**Ansible Playbook Tasks:**

```yaml
- Update system packages
- Install Docker & Docker Compose
- Configure firewall (ufw)
- Create app directory
- Copy docker-compose.yaml
- Create .env file
- Run docker-compose up -d
- Run database migrations
- Configure auto-start on reboot
```

**Docker Containers:**

- App (PHP 8.2 + Apache + Laravel)
- MySQL 8.0
- Traefik (optional)

### 5.2 PaaS Requirements

**Terraform Resources Needed:**

```
- azurerm_resource_group
- azurerm_service_plan (App Service Plan)
- azurerm_linux_web_app
- azurerm_mysql_flexible_server
- azurerm_mysql_flexible_database
- azurerm_app_service_source_control (for GitHub deploy)
```

**Deployment Method Options:**

1. **Docker Container** (from Docker Hub/ACR)
2. **GitHub Actions** (CI/CD pipeline)
3. **Local Git** (push to Azure)
4. **ZIP deploy** (upload code)

---

## 6. COMPARISON MATRIX: IaaS vs PaaS

| Aspect                | IaaS (VM + Docker)              | PaaS (App Service + MySQL)    |
| --------------------- | ------------------------------- | ----------------------------- |
| **Setup Time**        | 2-3 hours                       | 1-2 hours                     |
| **Complexity**        | High (manage OS, Docker, etc.)  | Low (managed service)         |
| **Control**           | Full control                    | Limited control               |
| **Scalability**       | Manual (resize VM)              | Automatic (auto-scale)        |
| **Cost (Budget)**     | $15.85/mo (B1s)                 | $0/mo (Free tier)             |
| **Cost (Production)** | $46/mo (B2s)                    | $95/mo (S1 + MySQL)           |
| **Maintenance**       | High (OS updates, Docker, etc.) | Low (Azure manages)           |
| **Monitoring**        | DIY (Azure Monitor + custom)    | Built-in (App Insights)       |
| **Backups**           | Manual setup required           | Automatic                     |
| **SSL**               | Manual (Let's Encrypt)          | Automatic (included)          |
| **Custom Domain**     | Easy (DNS pointing)             | Easy (built-in)               |
| **CI/CD**             | Setup GitHub Actions manually   | Easy (built-in deployment)    |
| **Flexibility**       | Can install anything            | Limited to supported runtimes |
| **Disaster Recovery** | Manual snapshots                | Automatic geo-redundancy      |

---

## 7. RECOMMENDATIONS

### For This Project (1-day timeline):

**IaaS Deployment:**

- Use **Standard_B1s** VM (saves credits)
- Use **Ubuntu 22.04 LTS**
- Deploy with **Docker Compose** (simplest)
- Skip Traefik (unnecessary for simple app)
- Use **file-based logging** (avoid Azure Log Analytics cost)
- **Basic monitoring** with Azure Monitor (free tier)

**PaaS Deployment:**

- Use **Free F1 tier** Web App (save credits)
- Use **MySQL In-App** (included, no extra cost)
- Deploy via **Docker container** (easiest)
- Enable **Application Insights** (free quota)
- Use **GitHub Actions** for CI/CD (bonus points)

### Best Practices for Resource Management:

**Naming Convention:**

```
{project}-{environment}-{resource}-{location}

Examples:
- terracloud-dev-vm-eastus
- terracloud-prod-webapp-eastus
- terracloud-dev-mysql-eastus
```

**Tagging Strategy:**

```terraform
tags = {
  Project     = "TerraCloud"
  Environment = "Development"
  ManagedBy   = "Terraform"
  Owner       = "YourName"
  CostCenter  = "Student"
}
```

**Cost Optimization:**

- Deallocate VMs when not in use
- Use B-series burstable VMs (cheapest)
- Delete unused resources daily
- Monitor spending via Azure Cost Management
- Set budget alerts ($10, $25, $50)

---

## 8. STRESS TESTING PLAN

### Tools to Use:

1. **Apache Bench (ab)** - Simple, pre-installed
2. **wrk** - Modern HTTP benchmarking tool
3. **Azure Load Testing** - Cloud-based (costs money)

### Test Scenarios:

**Scenario 1: Light Load**

```bash
ab -n 1000 -c 10 http://your-app-url/
# 1000 requests, 10 concurrent
```

**Scenario 2: Moderate Load**

```bash
ab -n 5000 -c 50 http://your-app-url/
# 5000 requests, 50 concurrent
```

**Scenario 3: Heavy Load**

```bash
ab -n 10000 -c 100 http://your-app-url/
# 10000 requests, 100 concurrent
```

**Scenario 4: API Endpoint Test**

```bash
ab -n 2000 -c 20 http://your-app-url/api/counter/add
# Test database write performance
```

### Metrics to Collect:

- **Requests per second (RPS)**
- **Average response time (ms)**
- **95th percentile response time**
- **Failed requests (count & percentage)**
- **Throughput (KB/s)**
- **CPU usage during test**
- **Memory usage during test**
- **Database connections**
