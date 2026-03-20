---
inclusion: fileMatch
fileMatchPattern: '**/*dynamodb*,**/*aws*'
description: DynamoDB best practices for table design, partition keys, and performance optimization
---

# DynamoDB Best Practices

Best practices for Amazon DynamoDB table design and optimization.

**Usage**: Automatically included when working on DynamoDB-related files, or use `#dynamodb-best-practices` in chat.

---

## Official Documentation

**📚 [AWS DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)**

Comprehensive guide covering table design, partition keys, indexes, and performance optimization.

## Key Best Practices

### Table Design

**Partition Key Design:**
- Use high-cardinality attributes (many distinct values)
- Distribute requests evenly across partition key values
- Avoid hot partitions (uneven access patterns)

**Sort Key Design:**
- Use for range queries and hierarchical data
- Enable efficient querying with composite keys
- Support multiple access patterns with GSIs

### Access Patterns

**Query over Scan:**
- Always prefer `Query` over `Scan` operations
- Use indexes to support query patterns
- Scan is expensive and should be avoided in production

**Batch Operations:**
- Use `BatchGetItem` and `BatchWriteItem` for multiple items
- Reduces API calls and improves throughput
- Max 25 items per batch request

### Performance Optimization

**Read/Write Capacity:**
- Use on-demand mode for unpredictable workloads
- Use provisioned mode with auto-scaling for predictable patterns
- Monitor CloudWatch metrics for throttling

**Item Size:**
- Keep items under 400 KB (hard limit)
- Smaller items = better performance
- Consider splitting large items across multiple records

**Indexes:**
- Use Global Secondary Indexes (GSI) for different access patterns
- Use Local Secondary Indexes (LSI) for alternate sort keys
- Limit projections to required attributes only

### Cost Optimization

- Use on-demand pricing for variable workloads
- Enable auto-scaling for provisioned capacity
- Use TTL to automatically delete expired items
- Archive old data to S3 using DynamoDB Streams

## Common Patterns

### Single Table Design

```
PK: USER#<userId>
SK: PROFILE#<userId>

PK: USER#<userId>
SK: ORDER#<orderId>

PK: ORDER#<orderId>
SK: ITEM#<itemId>
```

**Benefits:**
- Fewer tables to manage
- Transactional operations across entities
- Better cost efficiency

### Composite Keys

```
PK: TENANT#<tenantId>
SK: USER#<userId>#CREATED#<timestamp>
```

**Enables:**
- Multi-tenant isolation
- Time-based queries
- Hierarchical data access

## Anti-Patterns

- ❌ Using low-cardinality partition keys (e.g., status, type)
- ❌ Scanning tables in production code
- ❌ Not using indexes for query patterns
- ❌ Storing large binary data in items
- ❌ Using DynamoDB as a relational database

## Monitoring

**Key Metrics:**
- `ConsumedReadCapacityUnits` / `ConsumedWriteCapacityUnits`
- `ThrottledRequests`
- `SystemErrors`
- `UserErrors`

**Tools:**
- CloudWatch Metrics
- CloudWatch Contributor Insights
- X-Ray for request tracing

---

**For detailed guidance:**
- [DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html) - Official AWS guide
- [DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/) - Complete documentation
- Use MCP tool `mcp_aws_docs_read_documentation` to fetch latest AWS docs

**Related guides:**
- #[[file:../../security-policies.md]] - Security guidelines
- #[[file:../terraform-code-conventions.md]] - Infrastructure as Code
