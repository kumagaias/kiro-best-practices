---
inclusion: always
description: Security best practices including authentication, input validation, sanitization, and vulnerability prevention
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

### Requirements

- Use strong password policies (min 12 characters, complexity requirements)
- Implement multi-factor authentication (MFA) for sensitive operations
- Use secure session management
- Implement account lockout after failed attempts
- Use secure password hashing (bcrypt with 12+ rounds, Argon2)
- Implement role-based access control (RBAC)
- Validate permissions on every request
- Use JWT tokens with short expiration (15 minutes recommended)
- Implement refresh token rotation
- Use HTTPS-only cookies for tokens

## Input Validation & Sanitization

### Validation Rules

1. **Validate all inputs**: Never trust user input
2. **Whitelist approach**: Define allowed values, reject everything else
3. **Type checking**: Validate data types before processing
4. **Length limits**: Enforce maximum lengths for strings
5. **Format validation**: Use regex for email, phone, etc.

### Best Practices

- Use schema validation libraries (Zod, Joi, etc.)
- Validate email format and length (max 255 chars)
- Enforce password requirements (min 12 chars)
- Validate numeric ranges (age, quantities, etc.)
- Use enums for restricted values (roles, statuses, etc.)

### Sanitization Standards

- **HTML/XSS**: Use HTML sanitization libraries (DOMPurify), escape user input, use CSP headers
- **SQL Injection**: Always use parameterized queries or ORMs (Prisma, TypeORM, SQLAlchemy)
- **Command Injection**: Avoid shell commands, validate inputs
- **Path Traversal**: Validate file paths, use allowlists

## Vulnerability Prevention

### Common Vulnerabilities

Refer to [OWASP Top 10](https://owasp.org/www-project-top-ten/) for comprehensive vulnerability list.

**Key vulnerabilities to prevent:**
- SQL Injection: Use ORMs or parameterized queries
- XSS: Sanitize output, use CSP headers
- CSRF: Use CSRF tokens
- Broken Authentication: Implement secure session management
- Broken Access Control: Validate permissions on every request

### Dependency Security

- Regularly scan dependencies for vulnerabilities
- Keep all dependencies up to date
- Use dependency scanning tools (npm audit, Snyk, Dependabot)
- Remove unused dependencies

## Secure Coding Practices

### Error Handling

- Don't expose stack traces to users
- Log errors securely (no sensitive data)
- Use generic error messages for users
- Log detailed errors server-side only
- Return appropriate HTTP status codes

**Examples:**
- ❌ Bad: "Database connection failed: password123@localhost"
- ✅ Good: "Service temporarily unavailable" (user-facing)
- ✅ Good: Log detailed error server-side for debugging

### Logging Security

**Best Practices:**
- Remove sensitive data before logging (passwords, tokens, API keys)
- Use structured logging (JSON format)
- Include log levels (info, warn, error)
- Implement log rotation and retention policies

**Never log:**
- Passwords or password hashes
- Authentication tokens or session IDs
- API keys or secrets
- Credit card numbers or PII

## Security Headers

All web applications should implement these security headers:

- **X-Content-Type-Options**: `nosniff` - Prevents MIME type sniffing
- **X-Frame-Options**: `DENY` or `SAMEORIGIN` - Prevents clickjacking
- **Strict-Transport-Security**: `max-age=31536000; includeSubDomains` - Enforces HTTPS
- **Content-Security-Policy**: `default-src 'self'` - Controls resource loading
- **Referrer-Policy**: `no-referrer` or `strict-origin-when-cross-origin`

## Rate Limiting

### Best Practices

- Implement rate limiting on all public APIs
- Use stricter limits for authentication endpoints
- Track by IP address or user ID
- Return HTTP 429 (Too Many Requests) with Retry-After header

### Recommended Limits

- **General API**: 100 requests per 15 minutes per IP
- **Authentication**: 5 login attempts per 15 minutes per IP, implement account lockout
- **Public endpoints**: 10-20 requests per minute per IP

---

## Pre-deployment Security Checklist

- [ ] All secrets in environment variables
- [ ] Input validation on all endpoints
- [ ] Output sanitization implemented
- [ ] Authentication/authorization working
- [ ] HTTPS enabled
- [ ] Security headers configured
- [ ] Rate limiting implemented
- [ ] CORS configured properly
- [ ] Dependencies updated and scanned
- [ ] No hardcoded credentials

---

**Related guides:**
- #[[file:deployment-workflow.md]] - Deployment standards and checklist
- #[[file:testing-standards.md]] - Testing standards
- #[[file:languages/typescript-security-policies.md]] - TypeScript-specific security practices
- #[[file:languages/terraform-code-conventions.md]] - Terraform security best practices
