---
inclusion: always
---

# Security Guidelines

Security best practices and policies for application development.

**Usage**: Include this guide by typing `#security-policies` in chat.

---

## General Security Principles

- Never hardcode sensitive information
- Use environment variables for secrets
- Configure CORS appropriately
- Implement rate limiting
- Sanitize input data
- Apply principle of least privilege
- Use HTTPS for all communications
- Keep dependencies up to date

## Authentication & Authorization

### Authentication Requirements

- Use strong password policies (min 12 characters, complexity requirements)
- Implement multi-factor authentication (MFA) for sensitive operations
- Use secure session management
- Implement account lockout after failed attempts
- Use secure password hashing (bcrypt, Argon2)

### Authorization

- Implement role-based access control (RBAC)
- Validate permissions on every request
- Use JWT tokens with short expiration times
- Implement refresh token rotation
- Validate token signatures

### Implementation Guidelines

- Hash passwords with strong algorithms (bcrypt with 12+ rounds, Argon2)
- Generate JWT tokens with short expiration (15 minutes recommended)
- Store refresh tokens securely with rotation
- Implement secure session storage
- Use HTTPS-only cookies for tokens

**Language-specific examples**: See #[[file:languages/typescript-security-policies.md]] for TypeScript/JavaScript implementations

## Data Validation

### Input Validation Rules

1. **Validate all inputs**: Never trust user input
2. **Whitelist approach**: Define allowed values, reject everything else
3. **Type checking**: Validate data types before processing
4. **Length limits**: Enforce maximum lengths for strings
5. **Format validation**: Use regex for email, phone, etc.

### Validation Best Practices

- Use schema validation libraries (Zod, Joi, etc.)
- Validate email format and length (max 255 chars)
- Enforce password requirements (min 12 chars)
- Validate numeric ranges (age, quantities, etc.)
- Use enums for restricted values (roles, statuses, etc.)
- Return clear error messages without exposing internals

**Language-specific examples**: See #[[file:languages/typescript-security-policies.md]] for TypeScript/JavaScript implementations

## Input Sanitization

### Sanitization Standards

- **HTML/XSS**: Escape HTML entities, use DOMPurify
- **SQL Injection**: Use parameterized queries, ORMs
- **Command Injection**: Avoid shell commands, validate inputs
- **Path Traversal**: Validate file paths, use allowlists
- **LDAP Injection**: Escape special characters

### Sanitization Best Practices

**XSS Prevention:**
- Use HTML sanitization libraries (DOMPurify, etc.)
- Allow only safe HTML tags (b, i, em, strong, a)
- Restrict attributes (href only for links)
- Escape user input in templates
- Use Content Security Policy (CSP) headers

**SQL Injection Prevention:**
- Always use parameterized queries or prepared statements
- Use ORM frameworks (Prisma, TypeORM, SQLAlchemy, etc.)
- Never concatenate user input into SQL strings
- Validate and sanitize all database inputs

**Language-specific examples**: See #[[file:languages/typescript-security-policies.md]] for TypeScript/JavaScript implementations

## Vulnerability Prevention

### Common Vulnerabilities

1. **SQL Injection**: Use ORMs or parameterized queries
2. **XSS (Cross-Site Scripting)**: Sanitize output, use CSP headers
3. **CSRF (Cross-Site Request Forgery)**: Use CSRF tokens
4. **Insecure Deserialization**: Validate serialized data
5. **Broken Authentication**: Implement secure session management
6. **Sensitive Data Exposure**: Encrypt data at rest and in transit
7. **XML External Entities (XXE)**: Disable XML external entity processing
8. **Broken Access Control**: Validate permissions on every request
9. **Security Misconfiguration**: Use secure defaults
10. **Using Components with Known Vulnerabilities**: Keep dependencies updated

### Dependency Security

**General Practices:**
- Regularly scan dependencies for vulnerabilities
- Keep all dependencies up to date
- Review security advisories for your ecosystem
- Use lock files to ensure consistent versions
- Remove unused dependencies
- Use tools like Snyk or Dependabot

**Language-specific commands:**
- **Node.js/npm**: `npm audit`, `npm audit fix`
- **Python/pip**: `pip-audit`, `safety check`
- **Ruby/bundler**: `bundle audit`
- **Go**: `go list -m all | nancy sleuth`

## Secure Coding Practices

### Error Handling

- Don't expose stack traces to users
- Log errors securely (no sensitive data)
- Use generic error messages for users
- Implement proper error boundaries
- Never include credentials or secrets in error messages
- Log detailed errors server-side only
- Return appropriate HTTP status codes

**Examples:**
- ❌ Bad: "Database connection failed: password123@localhost"
- ✅ Good: "Service temporarily unavailable" (user-facing)
- ✅ Good: Log detailed error server-side for debugging

**Language-specific examples**: See #[[file:languages/typescript-security-policies.md]] for TypeScript/JavaScript implementations

### Logging Security

**Best Practices:**
- Remove sensitive data before logging (passwords, tokens, secrets, API keys)
- Use structured logging (JSON format)
- Include log levels (info, warn, error)
- Log stack traces only in development
- Implement log rotation and retention policies
- Secure log storage with appropriate access controls
- Monitor logs for suspicious activity

**Never log:**
- Passwords or password hashes
- Authentication tokens or session IDs
- API keys or secrets
- Credit card numbers or PII
- Internal system paths or configurations

**Language-specific examples**: See #[[file:languages/typescript-security-policies.md]] for TypeScript/JavaScript implementations

### Environment Variables

```bash
# .env.example (commit this)
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
JWT_SECRET=your-secret-key-here
API_KEY=your-api-key-here

# .env (never commit this)
DATABASE_URL=postgresql://prod_user:prod_pass@prod.example.com:5432/prod_db
JWT_SECRET=actual-secret-key
API_KEY=actual-api-key
```

## Security Headers

### Required Headers

All web applications should implement these security headers:

- **X-Content-Type-Options**: `nosniff` - Prevents MIME type sniffing
- **X-Frame-Options**: `DENY` or `SAMEORIGIN` - Prevents clickjacking
- **X-XSS-Protection**: `1; mode=block` - Enables XSS filtering
- **Strict-Transport-Security**: `max-age=31536000; includeSubDomains` - Enforces HTTPS
- **Content-Security-Policy**: `default-src 'self'` - Controls resource loading
- **Referrer-Policy**: `no-referrer` or `strict-origin-when-cross-origin`
- **Permissions-Policy**: Restrict browser features

**Language-specific examples**: See #[[file:languages/typescript-security-policies.md]] for TypeScript/JavaScript implementations

## Rate Limiting

### Best Practices

- Implement rate limiting on all public APIs
- Use stricter limits for authentication endpoints
- Track by IP address or user ID
- Return appropriate HTTP 429 (Too Many Requests) status
- Include Retry-After header in responses

### Recommended Limits

**General API endpoints:**
- 100 requests per 15 minutes per IP

**Authentication endpoints:**
- 5 login attempts per 15 minutes per IP
- Implement account lockout after repeated failures

**Public endpoints:**
- 10-20 requests per minute per IP

**Language-specific examples**: See #[[file:languages/typescript-security-policies.md]] for TypeScript/JavaScript implementations

## Security Checklist

### Pre-deployment Security Checks

- [ ] All secrets in environment variables
- [ ] Input validation on all endpoints
- [ ] Output sanitization implemented
- [ ] Authentication/authorization working
- [ ] HTTPS enabled
- [ ] Security headers configured
- [ ] Rate limiting implemented
- [ ] CORS configured properly
- [ ] Dependencies updated
- [ ] Security audit passed
- [ ] Gitleaks scan passed
- [ ] No hardcoded credentials
- [ ] Error messages don't expose internals
- [ ] Logging doesn't include sensitive data

### Regular Security Maintenance

- Weekly: Check for dependency vulnerabilities
- Monthly: Review access logs for suspicious activity
- Quarterly: Security audit and penetration testing
- Annually: Review and update security policies

## Incident Response

### When Security Incident Occurs

1. **Contain**: Isolate affected systems
2. **Assess**: Determine scope and impact
3. **Notify**: Inform stakeholders and users if needed
4. **Fix**: Patch vulnerability
5. **Document**: Create postmortem
6. **Learn**: Update security policies

### Postmortem Template

See #[[file:deployment-workflow.md]] for postmortem structure.

---

**Related guides:**
- #[[file:deployment-workflow.md]] - Project standards including postmortem guidelines
- #[[file:languages/typescript-security-policies.md]] - TypeScript-specific security practices
