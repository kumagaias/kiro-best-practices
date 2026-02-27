---
inclusion: fileMatch
fileMatchPattern: '**/*.(tf|tfvars)'
description: Terraform coding standards including style conventions, naming patterns, and best practices
---

# Terraform Code Conventions

Terraform coding standards, style conventions, and best practices.

**Usage**: Automatically included when working on Terraform files, or use `#terraform-code-conventions` in chat.

---

## Official Style Guide

Follow the official HashiCorp Terraform style conventions:

**📚 [Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style)**

The official guide covers:
- Code formatting standards
- Naming conventions
- File and directory structure
- Module organization
- Comments and documentation

## Quick Reference

### Formatting
- Use `terraform fmt` to automatically format code
- 2 spaces indentation
- Align equals signs in consecutive lines
- Use blank lines to separate logical sections

### Naming Conventions
- **Resources**: Use underscores, descriptive names (`aws_instance.web_server`)
- **Variables**: Use underscores, descriptive names (`instance_type`, `vpc_cidr`)
- **Outputs**: Use underscores, descriptive names (`instance_id`, `vpc_id`)
- **Modules**: Use hyphens in directory names (`vpc-module`, `ec2-instance`)

### File Organization
```
.
├── main.tf           # Primary resources
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── versions.tf       # Provider versions
├── terraform.tfvars  # Variable values (gitignored if sensitive)
└── modules/          # Local modules
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Best Practices

### Resource Naming
```hcl
# ✅ Good: Descriptive, uses underscores
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
}

# ❌ Avoid: Generic names
resource "aws_instance" "this" {
  # ...
}
```

### Variable Definitions
```hcl
# ✅ Good: With description and type
variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t3.micro"
}

# ✅ Good: Complex types
variable "vpc_config" {
  description = "VPC configuration"
  type = object({
    cidr_block           = string
    enable_dns_hostnames = bool
    enable_dns_support   = bool
  })
}
```

### Module Usage
```hcl
# ✅ Good: Clear module source and version
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = var.common_tags
}
```

### Comments
```hcl
# Use comments to explain WHY, not WHAT
# The code itself should be self-explanatory for WHAT

# We use a larger instance type here because this service
# requires more memory for in-memory caching
resource "aws_instance" "cache_server" {
  instance_type = "r5.large"
  # ...
}
```

## Security Best Practices

### Sensitive Data
```hcl
# ✅ Good: Mark sensitive variables
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# ✅ Good: Mark sensitive outputs
output "db_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}
```

### State Management
- Always use remote state (S3, Terraform Cloud)
- Enable state locking (DynamoDB for S3 backend)
- Encrypt state at rest
- Never commit `.tfstate` files to git

```hcl
# ✅ Good: Remote backend configuration
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

## Testing

### Validation
```bash
# Format check
terraform fmt -check

# Validate configuration
terraform validate

# Plan with detailed output
terraform plan -out=tfplan

# Security scanning (using Checkov)
checkov -d .
```

### Pre-commit Checks
- Run `terraform fmt`
- Run `terraform validate`
- Run security scans
- Review plan output

## Common Patterns

### Conditional Resources
```hcl
# ✅ Good: Use count for conditional creation
resource "aws_instance" "optional" {
  count = var.create_instance ? 1 : 0

  ami           = var.ami_id
  instance_type = var.instance_type
}
```

### Dynamic Blocks
```hcl
# ✅ Good: Use dynamic blocks for repeated nested blocks
resource "aws_security_group" "main" {
  name = "main-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

### Data Sources
```hcl
# ✅ Good: Use data sources for existing resources
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
```

## Prohibited Practices

- ❌ Hardcoding sensitive values (use variables or secrets management)
- ❌ Using `terraform apply` without reviewing plan
- ❌ Committing `.tfstate` files
- ❌ Using `latest` for provider versions (pin versions)
- ❌ Large monolithic configurations (use modules)
- ❌ Ignoring `terraform fmt` warnings

## Workflow

```bash
# 1. Initialize
terraform init

# 2. Format
terraform fmt -recursive

# 3. Validate
terraform validate

# 4. Plan
terraform plan -out=tfplan

# 5. Review plan output carefully

# 6. Apply
terraform apply tfplan

# 7. Verify changes
terraform show
```

---

**Related guides:**
- #[[file:../security-policies.md]] - General security guidelines
- #[[file:../testing-standards.md]] - Testing standards
- #[[file:../deployment-workflow.md]] - Deployment workflow

**External resources:**
- [Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style) - Official HashiCorp style conventions
- [Terraform Best Practices](https://www.terraform-best-practices.com/) - Community best practices
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) - AWS provider reference
