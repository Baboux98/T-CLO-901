## 📊 Performance Testing

After both deployments are running:

```bash
# Install Apache Bench (if not already installed)
# Test IaaS deployment
ab -n 1000 -c 10 http://<iaas-vm-ip>/

# Test PaaS deployment
ab -n 1000 -c 10 https://<app-service-url>/
```

Document results in `tests/stress-tests/`
