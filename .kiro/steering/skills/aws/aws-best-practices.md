---
inclusion: fileMatch
fileMatchPattern: '**/*aws*,**/*lambda*,**/*dynamodb*,**/*s3*,**/*ec2*,**/*rds*'
description: AWS Well-Architected Framework and best practices
---

# AWS Best Practices

Best practices for Amazon Web Services development and architecture.

**Usage**: Automatically included when working on AWS-related files, or use `#aws-best-practices` in chat.

---

## Official Documentation

**📚 [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html)**

Comprehensive framework covering operational excellence, security, reliability, performance efficiency, cost optimization, and sustainability.

## Key Resources

### Framework Pillars

- **🏠 [Main Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html)** - Complete Well-Architected Framework
- **🔒 [Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)** - Security best practices
- **⚡ [Operational Excellence](https://docs.aws.amazon.com/wellarchitected/latest/operational-excellence-pillar/welcome.html)** - Operations and reliability
- **💰 [Cost Optimization](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/welcome.html)** - Cost management
- **⚙️ [Performance Efficiency](https://docs.aws.amazon.com/wellarchitected/latest/performance-efficiency-pillar/welcome.html)** - Performance optimization
- **🔄 [Reliability](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html)** - System reliability
- **🌿 [Sustainability](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/sustainability-pillar.html)** - Environmental sustainability

### Architecture Resources

- **📋 [Architecture Center](https://aws.amazon.com/architecture/)** - Reference architectures and patterns
- **🏗️ [AWS Solutions Library](https://aws.amazon.com/solutions/)** - Pre-built solutions

## Core Principles

### Security
- Use IAM with least privilege
- Enable AWS CloudTrail for audit logging
- Use AWS Secrets Manager for sensitive data
- Implement VPC security groups and NACLs
- Enable encryption at rest and in transit

### Operational Excellence
- Use Infrastructure as Code (CloudFormation, CDK, Terraform)
- Implement CI/CD pipelines
- Monitor with CloudWatch
- Use AWS X-Ray for distributed tracing
- Automate operations with Systems Manager

### Cost Optimization
- Use Reserved Instances and Savings Plans
- Implement auto-scaling
- Use Spot Instances for batch workloads
- Monitor costs with AWS Cost Explorer
- Right-size resources based on usage

### Performance Efficiency
- Use CloudFront for content delivery
- Implement caching strategies (ElastiCache)
- Use appropriate instance types
- Optimize database queries
- Use managed services when possible

### Reliability
- Design for high availability across AZs
- Implement health checks and auto-healing
- Use managed services for durability
- Plan for disaster recovery
- Test failure scenarios

## Best Practices by Service

### Lambda
- Use container images with ECR for large dependencies
- Initialize SDK clients outside handler
- Implement proper error handling and retries
- Monitor cold starts and optimize
- Use environment variables for configuration

### DynamoDB
- Design efficient partition keys
- Use GSIs for query flexibility
- Implement on-demand or provisioned capacity
- Enable point-in-time recovery
- Use DynamoDB Streams for change capture

### S3
- Use appropriate storage classes
- Implement lifecycle policies
- Enable versioning for critical data
- Use presigned URLs for temporary access
- Implement proper bucket policies

### EC2
- Use Auto Scaling Groups
- Implement proper security groups
- Use Systems Manager for patching
- Enable detailed monitoring
- Use appropriate instance types

### RDS
- Use Multi-AZ for high availability
- Implement automated backups
- Use read replicas for scaling
- Enable Performance Insights
- Use appropriate instance types

## Infrastructure as Code

### Best Practices
- Use CDK or CloudFormation for AWS resources
- Use Terraform for multi-cloud
- Implement remote state management
- Use modules for reusability
- Version control all configurations

## Monitoring and Logging

### CloudWatch
- Set up dashboards for key metrics
- Implement alarms and notifications
- Use CloudWatch Logs Insights
- Monitor custom metrics
- Set up composite alarms

### X-Ray
- Implement distributed tracing
- Analyze service maps
- Identify performance bottlenecks
- Debug production issues
- Monitor service dependencies

## Security Best Practices

### Identity and Access Management
- Use IAM roles for applications
- Implement MFA for privileged accounts
- Use AWS Organizations for multi-account
- Enable AWS SSO
- Regular access reviews

### Network Security
- Use VPC for network isolation
- Implement security groups properly
- Use AWS WAF for web applications
- Enable VPC Flow Logs
- Use PrivateLink for service access

## Related Resources

- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- [AWS Solutions Library](https://aws.amazon.com/solutions/)
- [AWS Blog](https://aws.amazon.com/blogs/)
- [AWS re:Post](https://repost.aws/)

---

**Related guides:**
- #[[file:../../security-policies.md]] - Security guidelines
- #[[file:../terraform-code-conventions.md]] - Infrastructure as Code
- #[[file:lambda-best-practices.md]] - Lambda-specific best practices
- #[[file:dynamodb-best-practices.md]] - DynamoDB-specific best practices

