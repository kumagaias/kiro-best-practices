# Project Structure (AWS Hosting)

AWS-hosted project structure with Lambda, API Gateway, and infrastructure as code.

---

## Monorepo Structure

```
project-root/
├── frontend/              # Frontend application
│   ├── src/
│   │   ├── app/          # Next.js App Router
│   │   ├── components/   # React components
│   │   ├── lib/          # Utilities
│   │   └── types/        # TypeScript types
│   ├── public/           # Static assets
│   └── package.json
├── backend/               # Backend Lambda functions
│   ├── src/
│   │   ├── handlers/     # Lambda handlers
│   │   ├── services/     # Business logic
│   │   ├── repositories/ # Data access
│   │   ├── models/       # Data models
│   │   └── utils/        # Utilities
│   ├── tests/
│   └── package.json
├── infra/                 # Infrastructure as Code (Terraform)
│   ├── modules/          # Reusable Terraform modules
│   │   ├── api-gateway/
│   │   ├── lambda/
│   │   ├── dynamodb/
│   │   ├── s3/
│   │   └── cloudfront/
│   ├── environments/     # Environment-specific configs
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   └── main.tf
├── .kiro/                 # Kiro configuration
├── scripts/               # Utility scripts
├── Makefile
└── README.md
```

## Frontend Structure (Next.js on CloudFront + S3)

```
frontend/
├── src/
│   ├── app/              # Next.js App Router
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── api/         # API routes (optional)
│   ├── components/
│   │   ├── ui/          # Basic UI components
│   │   ├── features/    # Feature-specific components
│   │   └── layouts/     # Layout components
│   ├── lib/
│   │   ├── api/         # API client (calls API Gateway)
│   │   ├── aws/         # AWS SDK utilities
│   │   └── utils.ts
│   └── types/
├── public/
└── next.config.ts       # CloudFront/S3 optimized
```

## Backend Structure (Lambda Functions)

```
backend/
├── src/
│   ├── handlers/         # Lambda entry points
│   │   ├── api/         # API Gateway handlers
│   │   │   ├── users.ts
│   │   │   └── posts.ts
│   │   ├── events/      # EventBridge handlers
│   │   └── streams/     # DynamoDB Streams handlers
│   ├── services/         # Business logic
│   │   ├── userService.ts
│   │   └── postService.ts
│   ├── repositories/     # Data access layer
│   │   ├── userRepository.ts  # DynamoDB operations
│   │   └── postRepository.ts
│   ├── models/
│   │   ├── user.ts
│   │   └── post.ts
│   ├── middleware/       # Lambda middleware
│   │   ├── auth.ts
│   │   ├── cors.ts
│   │   └── errorHandler.ts
│   └── utils/
│       ├── dynamodb.ts   # DynamoDB utilities
│       ├── s3.ts         # S3 utilities
│       └── logger.ts     # CloudWatch logging
└── tests/
    ├── unit/
    └── integration/
```

## Infrastructure Structure (Terraform)

```
infra/
├── modules/              # Reusable modules
│   ├── api-gateway/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── lambda/
│   │   ├── main.tf      # Lambda function + IAM
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── dynamodb/
│   │   ├── main.tf      # DynamoDB table
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── s3/
│   │   ├── main.tf      # S3 bucket + CloudFront
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── cloudfront/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
└── backend.tf            # Terraform state (S3 + DynamoDB)
```

## AWS Services Architecture

```
┌─────────────────────────────────────────────────────┐
│                   CloudFront                        │
│              (CDN + SSL/TLS)                        │
└────────────┬────────────────────────┬───────────────┘
             │                        │
             │                        │
    ┌────────▼────────┐      ┌───────▼────────┐
    │   S3 Bucket     │      │  API Gateway   │
    │  (Static Site)  │      │   (REST API)   │
    └─────────────────┘      └───────┬────────┘
                                     │
                        ┌────────────┼────────────┐
                        │            │            │
                   ┌────▼───┐   ┌───▼────┐  ┌───▼────┐
                   │ Lambda │   │ Lambda │  │ Lambda │
                   │  (API) │   │ (Auth) │  │ (Jobs) │
                   └────┬───┘   └───┬────┘  └───┬────┘
                        │           │           │
                        └───────────┼───────────┘
                                    │
                            ┌───────▼────────┐
                            │   DynamoDB     │
                            │   (Database)   │
                            └────────────────┘
```

## Deployment Flow

### Development
```bash
# 1. Deploy infrastructure
cd infra/environments/dev
terraform init
terraform apply

# 2. Deploy backend
cd ../../../backend
npm run build
npm run deploy:dev  # AWS SAM or Serverless Framework

# 3. Deploy frontend
cd ../frontend
npm run build
aws s3 sync out/ s3://your-bucket-dev/
aws cloudfront create-invalidation --distribution-id XXX --paths "/*"
```

### Production
```bash
# Use CI/CD pipeline (GitHub Actions)
# Triggered on merge to main branch
```

## Environment Variables

### Frontend (.env.local)
```bash
NEXT_PUBLIC_API_URL=https://api.example.com
NEXT_PUBLIC_AWS_REGION=us-east-1
```

### Backend (Lambda Environment Variables)
```bash
DYNAMODB_TABLE_NAME=users-prod
AWS_REGION=us-east-1
LOG_LEVEL=info
```

### Infrastructure (terraform.tfvars)
```hcl
environment = "prod"
aws_region  = "us-east-1"
domain_name = "example.com"
```

## Best Practices

### Lambda Functions
- Keep functions small and focused
- Use Lambda Layers for shared dependencies
- Set appropriate timeout and memory
- Use environment variables for configuration
- Implement proper error handling and logging

### DynamoDB
- Design for access patterns
- Use single-table design when appropriate
- Implement proper indexes (GSI/LSI)
- Use DynamoDB Streams for event-driven architecture

### API Gateway
- Use request validation
- Implement rate limiting
- Enable CORS properly
- Use API keys or Cognito for authentication

### CloudFront + S3
- Enable compression
- Set appropriate cache headers
- Use CloudFront Functions for edge logic
- Implement proper security headers

## Cost Optimization

- Use Lambda reserved concurrency wisely
- Enable DynamoDB auto-scaling
- Use S3 lifecycle policies
- Monitor CloudWatch metrics
- Set up billing alerts

## Monitoring

- CloudWatch Logs for Lambda
- CloudWatch Metrics for performance
- X-Ray for distributed tracing
- CloudWatch Alarms for alerts
- CloudWatch Dashboards for visualization
