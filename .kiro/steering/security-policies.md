---
inclusion: manual
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

### Example: Secure Authentication

```typescript
// Password hashing
import bcrypt from 'bcrypt';

const hashPassword = async (password: string): Promise<string> => {
  const saltRounds = 12;
  return await bcrypt.hash(password, saltRounds);
};

// JWT token generation
import jwt from 'jsonwebtoken';

const generateToken = (userId: string): string => {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET!,
    { expiresIn: '15m' }
  );
};
```

## Data Validation

### Input Validation Rules

1. **Validate all inputs**: Never trust user input
2. **Whitelist approach**: Define allowed values, reject everything else
3. **Type checking**: Validate data types before processing
4. **Length limits**: Enforce maximum lengths for strings
5. **Format validation**: Use regex for email, phone, etc.

### Example: Input Validation

```typescript
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email().max(255),
  password: z.string().min(12).max(128),
  age: z.number().int().min(0).max(150),
  role: z.enum(['user', 'admin', 'moderator']),
});

// Validate input
const validateUser = (data: unknown) => {
  try {
    return userSchema.parse(data);
  } catch (error) {
    throw new Error('Invalid user data');
  }
};
```

## Input Sanitization

### Sanitization Standards

- **HTML/XSS**: Escape HTML entities, use DOMPurify
- **SQL Injection**: Use parameterized queries, ORMs
- **Command Injection**: Avoid shell commands, validate inputs
- **Path Traversal**: Validate file paths, use allowlists
- **LDAP Injection**: Escape special characters

### Example: XSS Prevention

```typescript
import DOMPurify from 'isomorphic-dompurify';

const sanitizeHtml = (dirty: string): string => {
  return DOMPurify.sanitize(dirty, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a'],
    ALLOWED_ATTR: ['href'],
  });
};

// SQL Injection Prevention (using Prisma)
const getUser = async (email: string) => {
  // Parameterized query - safe from SQL injection
  return await prisma.user.findUnique({
    where: { email },
  });
};
```

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

```bash
# Check vulnerabilities
npm audit

# Fix automatically
npm audit fix

# Fix with breaking changes
npm audit fix --force

# Check for outdated packages
npm outdated
```

## Secure Coding Practices

### Error Handling

- Don't expose stack traces to users
- Log errors securely (no sensitive data)
- Use generic error messages for users
- Implement proper error boundaries

```typescript
// Bad: Exposes internal details
throw new Error(`Database connection failed: ${dbConfig.password}`);

// Good: Generic message, log details separately
logger.error('Database connection failed', { error: err.message });
throw new Error('Service temporarily unavailable');
```

### Logging Security

```typescript
const logger = {
  info: (message: string, meta?: object) => {
    // Remove sensitive data before logging
    const sanitized = removeSensitiveData(meta);
    console.log(JSON.stringify({ level: 'info', message, ...sanitized }));
  },
  error: (message: string, error?: Error, meta?: object) => {
    const sanitized = removeSensitiveData(meta);
    console.error(JSON.stringify({ 
      level: 'error', 
      message, 
      error: error?.message,
      stack: process.env.NODE_ENV === 'development' ? error?.stack : undefined,
      ...sanitized 
    }));
  },
};

const removeSensitiveData = (data?: object) => {
  if (!data) return {};
  const { password, token, secret, ...safe } = data as any;
  return safe;
};
```

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

```typescript
// Express.js example
import helmet from 'helmet';

app.use(helmet());

// Or manually
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  res.setHeader('Content-Security-Policy', "default-src 'self'");
  next();
});
```

## Rate Limiting

```typescript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP',
});

app.use('/api/', limiter);

// Stricter limit for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: 'Too many login attempts',
});

app.use('/api/auth/login', authLimiter);
```

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

See `project.md` for postmortem structure.

---

**Related guides:**
- `#project` - Project standards including postmortem guidelines
- `#tech-typescript` - TypeScript-specific security practices
