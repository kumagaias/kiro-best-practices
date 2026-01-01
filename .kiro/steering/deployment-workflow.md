---
inclusion: manual
---

# Deployment Process

Deployment procedures, CI/CD pipeline configuration, and environment management.

**Usage**: Include this guide by typing `#deployment-workflow` in chat.

---

## Deployment Overview

### Environments

- **Development**: Local development environment
- **Staging**: Pre-production testing environment
- **Production**: Live production environment

### Deployment Strategy

- Use blue-green or canary deployments for zero-downtime
- Always deploy to staging first
- Automated rollback on failure
- Monitor metrics post-deployment

## Pre-deployment Checklist

Before deploying to any environment:

- [ ] All tests pass (`make test`)
- [ ] Security checks pass (`make test-security`)
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] Environment variables configured
- [ ] Database migrations tested
- [ ] Rollback plan prepared
- [ ] Monitoring alerts configured
- [ ] Stakeholders notified

## Build Procedures

### Build Process

```bash
# 1. Install dependencies
npm ci

# 2. Run linting
npm run lint

# 3. Run tests
npm test

# 4. Build application
npm run build

# 5. Run security checks
npm audit
gitleaks detect --source . --verbose
```

### Build Configuration

```json
// package.json
{
  "scripts": {
    "build": "tsc && vite build",
    "build:staging": "NODE_ENV=staging npm run build",
    "build:production": "NODE_ENV=production npm run build",
    "test": "vitest run",
    "test:ci": "vitest run --coverage",
    "lint": "eslint . --ext .ts,.tsx",
    "lint:fix": "eslint . --ext .ts,.tsx --fix"
  }
}
```

## Environment Configuration

### Environment Variables

Each environment should have its own configuration:

```bash
# .env.development
NODE_ENV=development
API_URL=http://localhost:3000
DATABASE_URL=postgresql://localhost:5432/dev_db
LOG_LEVEL=debug

# .env.staging
NODE_ENV=staging
API_URL=https://staging.example.com
DATABASE_URL=postgresql://staging-db.example.com:5432/staging_db
LOG_LEVEL=info

# .env.production
NODE_ENV=production
API_URL=https://api.example.com
DATABASE_URL=postgresql://prod-db.example.com:5432/prod_db
LOG_LEVEL=warn
```

### Environment-specific Requirements

**Development:**
- Hot reload enabled
- Debug logging
- Mock external services
- Relaxed CORS

**Staging:**
- Production-like configuration
- Real external services (test accounts)
- Monitoring enabled
- Strict CORS

**Production:**
- Optimized builds
- CDN enabled
- Full monitoring and alerting
- Strict security policies

## Deployment Steps

### Manual Deployment (Emergency Only)

```bash
# 1. Pull latest changes
git pull origin main

# 2. Install dependencies
npm ci

# 3. Run tests
make test

# 4. Build application
npm run build:production

# 5. Backup current version
cp -r dist dist.backup

# 6. Deploy new version
# (deployment method depends on infrastructure)

# 7. Verify deployment
curl https://api.example.com/health

# 8. Monitor logs
tail -f /var/log/app.log
```

### Automated Deployment (Recommended)

Use CI/CD pipeline for all deployments.

## CI/CD Pipeline

### GitHub Actions Example

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run linting
        run: npm run lint
        
      - name: Run tests
        run: npm test
        
      - name: Run security checks
        run: |
          npm audit
          npx gitleaks detect --source . --verbose

  deploy-staging:
    needs: test
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build
        run: npm run build:staging
        env:
          NODE_ENV: staging
          
      - name: Deploy to Staging
        run: |
          # Deploy to staging environment
          # (implementation depends on infrastructure)
          
      - name: Verify Deployment
        run: |
          curl -f https://staging.example.com/health || exit 1

  deploy-production:
    needs: deploy-staging
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build
        run: npm run build:production
        env:
          NODE_ENV: production
          
      - name: Deploy to Production
        run: |
          # Deploy to production environment
          # (implementation depends on infrastructure)
          
      - name: Verify Deployment
        run: |
          curl -f https://api.example.com/health || exit 1
          
      - name: Notify Team
        if: always()
        run: |
          # Send notification to team
          # (Slack, email, etc.)
```

## Deployment Strategies

### Blue-Green Deployment

```bash
# 1. Deploy to green environment (inactive)
deploy_to_green_environment

# 2. Run smoke tests on green
run_smoke_tests green

# 3. Switch traffic to green
switch_traffic_to green

# 4. Monitor for issues
monitor_metrics 5m

# 5. If issues, rollback to blue
if [ $? -ne 0 ]; then
  switch_traffic_to blue
fi
```

### Canary Deployment

```bash
# 1. Deploy new version to canary servers (10% traffic)
deploy_canary_version

# 2. Monitor metrics for 10 minutes
monitor_metrics 10m

# 3. If metrics good, increase to 50%
increase_canary_traffic 50

# 4. Monitor for 10 more minutes
monitor_metrics 10m

# 5. If still good, deploy to 100%
deploy_full_version

# 6. If issues at any point, rollback
if [ $? -ne 0 ]; then
  rollback_canary
fi
```

## Rollback Strategies

### Automatic Rollback

Configure automatic rollback on:
- Health check failures
- Error rate spike (> 5%)
- Response time degradation (> 2x baseline)
- Memory/CPU usage spike

### Manual Rollback

```bash
# 1. Identify last known good version
git log --oneline -10

# 2. Checkout previous version
git checkout <commit-hash>

# 3. Deploy previous version
npm ci
npm run build:production
# Deploy...

# 4. Verify rollback
curl https://api.example.com/health

# 5. Document incident
# Create postmortem (see project.md)
```

## Database Migrations

### Migration Strategy

- Always use forward-compatible migrations
- Test migrations on staging first
- Keep migrations reversible
- Backup database before migration

### Migration Example

```bash
# 1. Backup database
pg_dump production_db > backup_$(date +%Y%m%d_%H%M%S).sql

# 2. Run migration on staging
npm run migrate:staging

# 3. Verify staging
npm run test:integration

# 4. Run migration on production
npm run migrate:production

# 5. Verify production
curl https://api.example.com/health
```

## Monitoring & Verification

### Post-deployment Monitoring

Monitor these metrics for at least 30 minutes after deployment:

- **Error rate**: Should remain < 1%
- **Response time**: Should remain within 2x baseline
- **CPU usage**: Should remain < 80%
- **Memory usage**: Should remain < 80%
- **Request rate**: Should match expected traffic
- **Database connections**: Should remain stable

### Health Checks

```typescript
// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    // Check database
    await prisma.$queryRaw`SELECT 1`;
    
    // Check external services
    await fetch('https://external-api.example.com/health');
    
    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      version: process.env.APP_VERSION,
    });
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      error: error.message,
    });
  }
});
```

### Smoke Tests

```bash
# Run after deployment
npm run test:smoke

# Or manually
curl -f https://api.example.com/health
curl -f https://api.example.com/api/v1/status
# Test critical endpoints...
```

## Deployment Notifications

### Notify Team

Send notifications on:
- Deployment started
- Deployment completed
- Deployment failed
- Rollback initiated

### Notification Example

```bash
# Slack notification
curl -X POST https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
  -H 'Content-Type: application/json' \
  -d '{
    "text": "🚀 Deployment to production started",
    "attachments": [{
      "color": "good",
      "fields": [
        {"title": "Version", "value": "v1.2.3", "short": true},
        {"title": "Environment", "value": "production", "short": true},
        {"title": "Deployed by", "value": "GitHub Actions", "short": true}
      ]
    }]
  }'
```

## Deployment Best Practices

1. **Always deploy during low-traffic hours** (if possible)
2. **Never deploy on Fridays** (unless emergency)
3. **Always have someone on-call** during deployment
4. **Test rollback procedure** before deploying
5. **Document all changes** in changelog
6. **Monitor metrics** for at least 30 minutes post-deployment
7. **Keep deployment window short** (< 30 minutes)
8. **Use feature flags** for risky changes
9. **Gradual rollout** for major changes
10. **Always have rollback plan** ready

---

**Related guides:**
- `#project` - Project standards including deployment checklist
- `#security-policies` - Security requirements for deployment
