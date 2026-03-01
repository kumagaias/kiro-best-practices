---
inclusion: fileMatch
fileMatchPattern: '**/*lambda*'
description: AWS Lambda best practices for function design, performance, and cost optimization
---

# AWS Lambda Best Practices

Best practices for AWS Lambda function development and optimization.

**Usage**: Automatically included when working on Lambda-related files, or use `#lambda-best-practices` in chat.

---

## Official Documentation

**📚 [AWS Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)**

Comprehensive guide covering function design, performance optimization, and operational excellence.

## Key Best Practices

### Function Design

**Keep Functions Focused:**
- Single responsibility per function
- Small, focused functions are easier to test and maintain
- Separate business logic from handler code

**Minimize Package Size:**
- Include only necessary dependencies
- Use Lambda Layers for shared code
- Smaller packages = faster cold starts

**Environment Variables:**
- Use for configuration (not secrets)
- Store secrets in AWS Secrets Manager or Parameter Store
- Encrypt sensitive environment variables

### Performance Optimization

**Cold Start Reduction:**
- Minimize package size and dependencies
- Use provisioned concurrency for latency-sensitive functions
- Keep functions warm with scheduled invocations (if needed)
- Initialize SDK clients outside handler

**Memory Configuration:**
- More memory = more CPU power
- Test different memory settings for cost/performance balance
- Use AWS Lambda Power Tuning tool

**Connection Reuse:**
- Reuse connections (database, HTTP clients)
- Initialize connections outside handler
- Use connection pooling

### Error Handling

**Implement Retry Logic:**
- Use exponential backoff for retries
- Set appropriate retry limits
- Use Dead Letter Queues (DLQ) for failed events

**Logging:**
- Use structured logging (JSON format)
- Include correlation IDs for tracing
- Log errors with context
- Use CloudWatch Logs Insights for analysis

### Security

**Least Privilege IAM:**
- Grant minimum required permissions
- Use resource-based policies when possible
- Avoid wildcard permissions

**VPC Configuration:**
- Only use VPC when accessing private resources
- Use VPC endpoints to avoid NAT gateway costs
- Configure security groups properly

### Cost Optimization

**Right-Size Memory:**
- Monitor actual memory usage
- Adjust memory allocation accordingly
- Higher memory can reduce execution time (lower cost)

**Optimize Execution Time:**
- Reduce function duration
- Use asynchronous processing when possible
- Batch operations when appropriate

**Use Reserved Concurrency:**
- Prevent runaway costs
- Control concurrent executions
- Protect downstream resources

## Common Patterns

### Handler Pattern

```python
import json
import boto3

# Initialize outside handler
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('MyTable')

def lambda_handler(event, context):
    try:
        # Business logic
        result = process_event(event)
        return {
            'statusCode': 200,
            'body': json.dumps(result)
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
```

### Async Processing

```python
# Use async invocation for non-critical operations
lambda_client.invoke(
    FunctionName='ProcessorFunction',
    InvocationType='Event',  # Async
    Payload=json.dumps(data)
)
```

## Anti-Patterns

- ❌ Storing state in function memory
- ❌ Using recursive Lambda invocations
- ❌ Hardcoding configuration values
- ❌ Not implementing timeouts
- ❌ Ignoring cold start optimization
- ❌ Over-provisioning memory

## Monitoring

**Key Metrics:**
- `Duration` - Execution time
- `Errors` - Function errors
- `Throttles` - Concurrent execution limits
- `ConcurrentExecutions` - Active instances
- `IteratorAge` - Stream processing lag (for event sources)

**Tools:**
- CloudWatch Metrics and Logs
- X-Ray for distributed tracing
- CloudWatch Insights for log analysis
- AWS Lambda Power Tuning

---

**For detailed guidance:**
- [AWS Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html) - Official guide
- [Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/) - Complete documentation
- Use MCP tool `mcp_aws_docs_read_documentation` to fetch latest AWS docs

**Related guides:**
- #[[file:../../security-policies.md]] - Security guidelines
- #[[file:../terraform-code-conventions.md]] - Infrastructure as Code
- #[[file:dynamodb-best-practices.md]] - DynamoDB integration
