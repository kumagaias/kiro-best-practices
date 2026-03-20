---
inclusion: fileMatch
fileMatchPattern: '**/*gcp*,**/*google*,**/*gcloud*'
description: Google Cloud Platform best practices and Well-Architected Framework
---

# Google Cloud Best Practices

Best practices for Google Cloud Platform development and architecture.

**Usage**: Automatically included when working on GCP-related files, or use `#gcp-best-practices` in chat.

---

## Official Documentation

**📚 [Google Cloud Well-Architected Framework](https://cloud.google.com/architecture/framework)**

Comprehensive framework covering operational excellence, security, reliability, cost optimization, and performance efficiency.

## Key Resources

### Framework Pillars

- **🏠 [Main Framework](https://cloud.google.com/architecture/framework)** - Complete Well-Architected Framework
- **🔒 [Security](https://cloud.google.com/architecture/framework/security)** - Security best practices and controls
- **⚡ [Operational Excellence](https://cloud.google.com/architecture/framework/operational-excellence)** - Operations and reliability
- **🌿 [Sustainability](https://cloud.google.com/architecture/framework/sustainability)** - Environmental sustainability practices

### Architecture Resources

- **📋 [Architecture Center](https://cloud.google.com/architecture)** - Reference architectures and patterns
- **🏗️ [Architecture Framework](https://cloud.google.com/architecture/framework)** - Design principles and best practices

## Core Principles

### Security
- Use IAM for access control with least privilege
- Enable VPC Service Controls for data protection
- Implement Cloud Armor for DDoS protection
- Use Secret Manager for sensitive data
- Enable audit logging and monitoring

### Operational Excellence
- Use Infrastructure as Code (Terraform, Deployment Manager)
- Implement CI/CD pipelines
- Monitor with Cloud Monitoring and Logging
- Use Cloud Trace for distributed tracing
- Implement proper error handling and alerting

### Cost Optimization
- Use committed use discounts
- Implement autoscaling
- Use preemptible VMs for batch workloads
- Monitor costs with Cloud Billing
- Right-size resources based on usage

### Performance
- Use Cloud CDN for content delivery
- Implement caching strategies
- Use Cloud Load Balancing
- Optimize database queries
- Use appropriate storage classes

### Reliability
- Design for high availability across zones/regions
- Implement health checks and auto-healing
- Use managed services when possible
- Plan for disaster recovery
- Test failure scenarios

## Best Practices by Service

### Compute Engine
- Use instance templates and managed instance groups
- Implement startup scripts for configuration
- Use custom images for faster deployment
- Enable live migration for maintenance
- Use appropriate machine types

### Cloud Run
- Design stateless containers
- Use Cloud Build for CI/CD
- Implement proper health checks
- Use concurrency settings appropriately
- Monitor cold starts

### Cloud Functions
- Keep functions focused and small
- Use environment variables for configuration
- Implement proper error handling
- Monitor execution time and memory
- Use appropriate runtime versions

### Cloud Storage
- Use appropriate storage classes
- Implement lifecycle policies
- Enable versioning for critical data
- Use signed URLs for temporary access
- Implement proper IAM policies

### BigQuery
- Partition and cluster tables
- Use materialized views
- Implement cost controls
- Optimize query performance
- Use appropriate data types

## Infrastructure as Code

### Terraform Best Practices
- Use modules for reusability
- Implement remote state with Cloud Storage
- Use workspaces for environments
- Version control all configurations
- Implement proper naming conventions

## Monitoring and Logging

### Cloud Monitoring
- Set up dashboards for key metrics
- Implement alerting policies
- Use uptime checks
- Monitor SLIs and SLOs
- Use custom metrics when needed

### Cloud Logging
- Structure logs in JSON format
- Use appropriate log levels
- Implement log-based metrics
- Set up log sinks for analysis
- Retain logs according to compliance

## Security Best Practices

### Identity and Access Management
- Use service accounts for applications
- Implement organization policies
- Use groups for permission management
- Enable MFA for user accounts
- Regular access reviews

### Network Security
- Use VPC firewall rules
- Implement private Google access
- Use Cloud NAT for outbound traffic
- Enable VPC Flow Logs
- Use Cloud Armor for web applications

## Related Resources

- [Google Cloud Architecture Center](https://cloud.google.com/architecture)
- [Google Cloud Solutions](https://cloud.google.com/solutions)
- [Google Cloud Blog](https://cloud.google.com/blog)

---

**Related guides:**
- #[[file:../../security-policies.md]] - Security guidelines
- #[[file:../terraform-code-conventions.md]] - Infrastructure as Code
- #[[file:../aws/lambda-best-practices.md]] - Serverless patterns (AWS comparison)

