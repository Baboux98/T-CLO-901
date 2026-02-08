# PaaS Deployment with Terraform

This folder contains Terraform code to deploy your Laravel application to Azure using **Platform as a Service (PaaS)**.

## What Gets Created

- **Resource Group** - Container for all Azure resources
- **App Service Plan** - Compute resources for your web app
- **App Service (Linux)** - Hosts your Laravel application in Docker
- **MySQL Flexible Server** - Managed database service
- **MySQL Database** - Your Laravel database
- **Firewall Rules** - Allow App Service and your machine to access the database

## Prerequisites

Before you start, you need:

1. **Azure CLI** - [Install here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
2. **Terraform** - [Install here](https://www.terraform.io/downloads)
3. **Azure Student Subscription** - You already have this! ✓

## Step-by-Step Deployment

### 1. Login to Azure

```powershell
az login
```

This opens your browser - login with your Azure student account.

### 2. Verify Your Subscription

```powershell
az account show
```

This shows your active subscription. Make sure it's your student subscription.

### 3. Customize Your Configuration

Edit `terraform.tfvars` and change:

- `app_name` - Choose a unique name (lowercase, no spaces)
- `db_admin_password` - Set a strong password
- `location` - Choose your preferred Azure region

### 4. Initialize Terraform

```powershell
cd terraform/paas
terraform init
```

This downloads the Azure provider and sets up Terraform.

### 5. Preview the Changes

```powershell
terraform plan
```

This shows what Terraform will create (doesn't actually create anything yet).

### 6. Deploy to Azure

```powershell
terraform apply
```

Type `yes` when prompted. This takes 5-10 minutes.

### 7. Get Your App URL

After deployment, Terraform will show:

- **app_url** - Your Laravel app URL
- **mysql_server_fqdn** - Database server address
- Other helpful information

## Important Notes

### Costs

With Azure Student subscription:

- You get **$100 credit**
- Basic tier resources are affordable (a few dollars per month)
- Remember to destroy resources when not in use!

### Security

- **Never commit** `terraform.tfvars` to Git (already in `.gitignore`)
- Change the default password in `terraform.tfvars`
- In production, use Azure Key Vault for secrets

### Next Steps

After deployment:

1. Build and push your Laravel Docker image
2. Configure App Service to use your image
3. Run database migrations
4. Test your application

## Useful Commands

```powershell
# View current infrastructure
terraform show

# View output values
terraform output

# Destroy all resources (careful!)
terraform destroy

# Format Terraform files
terraform fmt

# Validate configuration
terraform validate
```

## Troubleshooting

**Error: Name already exists**

- Change `app_name` in `terraform.tfvars` to something unique

**Error: Quota exceeded**

- Check your Azure Student subscription limits
- Try a different region

**Error: Authentication failed**

- Run `az login` again
- Verify you're using the correct subscription: `az account show`

## File Structure

- **providers.tf** - Azure provider configuration
- **variables.tf** - Input variables (like function parameters)
- **main.tf** - Main resources (what gets created)
- **outputs.tf** - Output values (shown after deployment)
- **terraform.tfvars** - Your actual values (⚠️ sensitive - not in Git)

## Learning Resources

- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure App Service Docs](https://docs.microsoft.com/en-us/azure/app-service/)
- [Terraform Tutorial](https://learn.hashicorp.com/terraform)

---

**Ready to deploy?** Start with Step 1 above!
