---
inclusion: fileMatch
fileMatchPattern: '**/*.(tf|tfvars)'
description: Terraform coding standards with AWS best practices via MCP resources
---

# Terraform Code Conventions

Terraform coding standards and AWS best practices.

**Usage**: Automatically included when working on Terraform files, or use `#terraform-code-conventions` in chat.

---

## MCP Resources (AI-Accessible)

When working with AWS Terraform, use these MCP resources for comprehensive guidance:

- `terraform://aws_best_practices` - AWS-specific Terraform best practices
- `terraform://workflow_guide` - Security-focused development workflow
- `terraform://aws_provider_resources_listing` - AWS provider resources
- `terraform://awscc_provider_resources_listing` - AWSCC (Cloud Control API) resources

These resources include AWS Well-Architected guidance and Checkov security compliance.

## Essential Standards

### Formatting
- Use `terraform fmt` to automatically format code
- 2 spaces indentation
- Use blank lines to separate logical sections

### Naming Conventions
- **Resources/Variables/Outputs**: Use underscores (`web_server`, `instance_type`)
- **Modules**: Use hyphens in directory names (`vpc-module`)

### File Organization
```
.
├── main.tf           # Primary resources
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── versions.tf       # Provider versions
└── modules/          # Local modules
```

### Security Essentials
```hcl
# Mark sensitive variables
variable "db_password" {
  type      = string
  sensitive = true
}

# Remote state with encryption
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

## Workflow

```bash
terraform fmt -recursive    # Format
terraform validate          # Validate
terraform plan -out=tfplan  # Plan
terraform apply tfplan      # Apply
```

## Prohibited Practices

- ❌ Hardcoding sensitive values
- ❌ Committing `.tfstate` files
- ❌ Using `latest` for provider versions
- ❌ Ignoring `terraform fmt` warnings

---

**For detailed guidance:**
- Use MCP resource `terraform://aws_best_practices` for AWS-specific patterns
- Use MCP resource `terraform://workflow_guide` for security workflow
- [Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style) - Official conventions

**Related guides:**
- #[[file:../security-policies.md]] - Security guidelines
- #[[file:../deployment-workflow.md]] - Deployment workflow
