## 💰 Cost Management

**Important:** Azure Student gives you $100 credit, but resources still cost money!

### Estimated Monthly Costs

**IaaS:**

- VM (B1s): ~$10-15/month
- Storage: ~$2-5/month
- **Total: ~$12-20/month**

**PaaS:**

- App Service (B1): ~$13/month
- MySQL Flexible Server (B1ms): ~$15/month
- **Total: ~$28/month**

### Cost Optimization Tips

1. **Destroy resources when not using:**

   ```powershell
   terraform destroy
   ```

2. **Use Basic/Free tiers for learning**

3. **Monitor spending:**

   ```powershell
   az consumption usage list
   ```

4. **Set up budget alerts in Azure Portal**

## 🔄 Comparison Matrix

| Aspect               | IaaS (VM)                     | PaaS (App Service)                 |
| -------------------- | ----------------------------- | ---------------------------------- |
| **Setup Complexity** | High (VM, Docker, Ansible)    | Low (managed service)              |
| **Management**       | You manage OS, updates        | Azure manages everything           |
| **Scaling**          | Manual (create more VMs)      | Automatic/Easy                     |
| **Cost**             | Lower (~$12-20/mo)            | Higher (~$28/mo)                   |
| **Flexibility**      | Full control                  | Limited to Azure's options         |
| **Maintenance**      | You patch, update, secure     | Azure handles it                   |
| **Deployment Time**  | Slower (15-20 min)            | Faster (5-10 min)                  |
| **Best For**         | Custom requirements, learning | Quick deployment, less maintenance |
