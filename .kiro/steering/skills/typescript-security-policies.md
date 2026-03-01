---
inclusion: fileMatch
fileMatchPattern: '**/*.(ts|tsx|js|jsx)'
description: TypeScript/JavaScript security practices including dependency management, input validation, and XSS prevention
---

# TypeScript Security Policies

TypeScript/JavaScript-specific security practices.

**Usage**: Automatically included when working on TypeScript files, or use `#typescript-security-policies` in chat.

**Note**: See #[[file:../security-policies.md]] for general security guidelines.

---

## Dependency Security

```bash
npm audit              # Check vulnerabilities
npm audit fix          # Fix automatically
npm outdated           # Check outdated packages
npm ci                 # Use in production (respects lock file)
```

**Best Practices**:
- Run `npm audit` before deployment
- Use `package-lock.json` or `yarn.lock`
- Use Snyk or Dependabot for monitoring

## Input Validation (Zod)

```typescript
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email().max(255),
  password: z.string().min(12).max(128),
  age: z.number().int().min(0).max(150),
  role: z.enum(['user', 'admin']),
});

export function validateUser(data: unknown): User {
  return userSchema.parse(data);
}
```

## XSS Prevention

```typescript
// ✅ React automatically escapes
<div>{userInput}</div>

// ✅ Sanitize HTML when needed
import DOMPurify from 'isomorphic-dompurify';

const sanitizeHtml = (dirty: string): string => {
  return DOMPurify.sanitize(dirty, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a', 'p'],
    ALLOWED_ATTR: ['href'],
  });
};
```

## SQL Injection Prevention

```typescript
// ✅ Good: Prisma ORM (parameterized)
const user = await prisma.user.findUnique({
  where: { email: userEmail },
});

// ✅ Good: Parameterized query
const users = await db.query(
  'SELECT * FROM users WHERE email = $1',
  [userEmail]
);

// ❌ Never: String concatenation
const users = await db.query(
  `SELECT * FROM users WHERE email = '${userEmail}'`
);
```

## Authentication

```typescript
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

// Hash password
export async function hashPassword(password: string): Promise<string> {
  return await bcrypt.hash(password, 12);
}

// Generate JWT
export function generateToken(userId: string): string {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET!,
    { expiresIn: '15m' }
  );
}
```

## Environment Variables

```typescript
// ✅ Good: Validate at startup
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
  NODE_ENV: z.enum(['development', 'production', 'test']),
});

export const env = envSchema.parse(process.env);
```

## Rate Limiting

```typescript
import rateLimit from 'express-rate-limit';

const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Too many requests',
});

app.use('/api/', apiLimiter);
```

## Security Checklist

- [ ] All secrets in environment variables
- [ ] Input validation on all endpoints
- [ ] XSS prevention implemented
- [ ] SQL injection prevention verified
- [ ] Dependencies updated (`npm audit`)
- [ ] No console.logs with sensitive data
- [ ] Error messages don't expose internals

---

**Related guides:**
- #[[file:typescript-code-conventions.md]] - Coding standards
- #[[file:../security-policies.md]] - General security
