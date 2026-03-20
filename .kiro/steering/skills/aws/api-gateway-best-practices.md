---
inclusion: fileMatch
fileMatchPattern: '**/*api*gateway*,**/*apigw*,**/*aws*'
description: API Gateway best practices for security, performance, and cost optimization
---

# API Gateway Best Practices

Best practices for Amazon API Gateway design, security, and optimization.

**Usage**: Automatically included when working on API Gateway-related files, or use `#api-gateway-best-practices` in chat.

---

## Official Documentation

**📚 [API Gateway Security Best Practices](https://docs.aws.amazon.com/apigateway/latest/developerguide/security-best-practices.html)**

Comprehensive guide covering authentication, authorization, throttling, and security controls.

## Key Best Practices

### Security

**Authentication & Authorization:**
- Use IAM roles and policies for AWS service integration
- Implement Amazon Cognito for user authentication
- Use Lambda authorizers for custom authorization logic
- Enable AWS WAF for protection against common web exploits

**API Keys & Usage Plans:**
- Use API keys for identifying clients (not for authorization)
- Implement usage plans for rate limiting and quotas
- Rotate API keys regularly
- Never expose API keys in client-side code

**Encryption:**
- Use TLS 1.2 or higher for all API endpoints
- Enable CloudFront for additional DDoS protection
- Use AWS Certificate Manager for SSL/TLS certificates

### Throttling & Rate Limiting

**Throttle Settings:**
- Set account-level throttle limits
- Configure method-level throttle limits for critical endpoints
- Use burst limits to handle traffic spikes
- Monitor throttling metrics in CloudWatch

**Usage Plans:**
- Create tiered usage plans (free, basic, premium)
- Set appropriate rate limits per tier
- Configure quota limits (daily, weekly, monthly)

### Performance Optimization

**Caching:**
- Enable API caching for frequently accessed data
- Set appropriate TTL values (balance freshness vs performance)
- Use cache key parameters to cache different responses
- Invalidate cache when data changes

**Integration Optimization:**
- Use proxy integration for simpler Lambda functions
- Enable compression for large responses
- Minimize payload sizes
- Use regional endpoints for lower latency

### Cost Optimization

**Caching Strategy:**
- **IMPORTANT**: API Gateway caching is expensive - disable in development environments
- Start with caching disabled even in production
- Enable caching only after measuring actual performance needs and cost impact
- When enabled, set appropriate TTL values to balance cost vs performance

**Reduce API Calls:**
- Implement caching to reduce backend calls (only when cost-justified)
- Use batch operations when possible
- Optimize Lambda function execution time

**Choose Right Endpoint Type:**
- Regional: Lower latency for single region
- Edge-optimized: Global distribution via CloudFront
- Private: VPC-only access (no internet exposure)

### Monitoring & Logging

**CloudWatch Metrics:**
- Monitor `4XXError` and `5XXError` rates
- Track `Count` (total requests)
- Monitor `Latency` and `IntegrationLatency`
- Set up alarms for anomalies

**Access Logging:**
- Enable CloudWatch Logs for detailed request/response logging
- Use structured logging format
- Include correlation IDs for tracing
- Avoid logging sensitive data

**X-Ray Tracing:**
- Enable AWS X-Ray for distributed tracing
- Trace end-to-end request flow
- Identify performance bottlenecks

## Common Patterns

### Lambda Proxy Integration

```json
{
  "statusCode": 200,
  "headers": {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  },
  "body": "{\"message\": \"Success\"}"
}
```

### Request Validation

```yaml
# OpenAPI/Swagger schema
requestValidator: "Validate body, query string parameters, and headers"
requestModels:
  application/json: "UserModel"
```

### CORS Configuration

```yaml
responses:
  headers:
    Access-Control-Allow-Origin:
      type: "string"
    Access-Control-Allow-Methods:
      type: "string"
    Access-Control-Allow-Headers:
      type: "string"
```

## Anti-Patterns

- ❌ Using API keys for authorization (use IAM or Cognito)
- ❌ Not implementing throttling (risk of cost overruns)
- ❌ Exposing internal error details to clients
- ❌ Not enabling access logging
- ❌ Using edge-optimized endpoints for single-region apps
- ❌ Not validating request payloads

## API Types

### REST API
- Full-featured API management
- Request/response transformation
- API caching support
- Best for complex APIs

### HTTP API
- Lower cost (up to 70% cheaper)
- Lower latency
- Simpler feature set
- Best for simple proxy use cases

### WebSocket API
- Persistent connections
- Real-time bidirectional communication
- Best for chat, gaming, streaming

## Security Checklist

- [ ] TLS 1.2+ enabled
- [ ] Authentication configured (IAM/Cognito/Lambda authorizer)
- [ ] Throttling limits set
- [ ] Usage plans configured
- [ ] Request validation enabled
- [ ] Access logging enabled
- [ ] CloudWatch alarms configured
- [ ] AWS WAF enabled (if needed)
- [ ] CORS configured properly
- [ ] API keys rotated regularly

---

**For detailed guidance:**
- [API Gateway Security Best Practices](https://docs.aws.amazon.com/apigateway/latest/developerguide/security-best-practices.html) - Official guide
- [API Gateway Developer Guide](https://docs.aws.amazon.com/apigateway/latest/developerguide/) - Complete documentation
- Use MCP tool `mcp_aws_docs_read_documentation` to fetch latest AWS docs

**Related guides:**
- #[[file:../../security-policies.md]] - Security guidelines
- #[[file:../terraform-code-conventions.md]] - Infrastructure as Code
- #[[file:lambda-best-practices.md]] - Lambda integration
