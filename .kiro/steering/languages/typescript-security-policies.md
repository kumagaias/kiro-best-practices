---
inclusion: fileMatch
fileMatchPattern: '**/*.(ts|tsx|js|jsx)'
---

# TypeScript Security Policies

Security best practices specific to TypeScript/JavaScript applications.

**Usage**: Automatically included when working on TypeScript files, or use `#typescript-security-policies` in chat.

---

## Dependency Security

### Regular Audits

```bash
# Check vulnerabilities
npm audit

# Fix automatically (non-breaking)
npm audit fix

# Fix with breaking changes (use with caution)
npm audit fix --force

# Check for outdated packages
npm outdated

# Update specific package
npm update <package-name>
```

### Best Practices

- Run `npm audit` before every deployment
- Keep dependencies up to date
- Review security advisories regularly
- Use `package-lock.json` or `yarn.lock`
- Avoid packages with known vulnerabilities
- Use tools like Snyk or Dependabot

### Lock File Management

```bash
# Use exact versions in production
npm ci  # Instead of npm install

# Update lock file
npm install --package-lock-only
```

## Input Validation

### Zod Validation

```typescript
import { z } from 'zod';

// Define schema
const userSchema = z.object({
  email: z.string().email().max(255),
  password: z.string().min(12).max(128),
  age: z.number().int().min(0).max(150),
  role: z.enum(['user', 'admin', 'moderator']),
});

// Validate input
export function validateUser(data: unknown): User {
  try {
    return userSchema.parse(data);
  } catch (error) {
    if (error instanceof z.ZodError) {
      throw new ValidationError('Invalid user data', error.errors);
    }
    throw error;
  }
}

// API endpoint example
app.post('/api/users', async (req, res) => {
  try {
    const validatedData = validateUser(req.body);
    const user = await createUser(validatedData);
    res.status(201).json(user);
  } catch (error) {
    if (error instanceof ValidationError) {
      res.status(400).json({ error: error.message });
    } else {
      res.status(500).json({ error: 'Internal server error' });
    }
  }
});
```

### API Input Validation

```typescript
// ✅ Good: Validate all inputs
const apiSchema = z.object({
  query: z.string().max(100),
  page: z.number().int().min(1).max(1000),
  limit: z.number().int().min(1).max(100),
});

// ✅ Good: Sanitize file paths
function validateFilePath(path: string): string {
  const normalized = path.normalize(path);
  if (normalized.includes('..')) {
    throw new Error('Invalid file path');
  }
  return normalized;
}
```

## XSS Prevention

### React/Next.js

```typescript
// ✅ Good: React automatically escapes
<div>{userInput}</div>

// ⚠️ Dangerous: Only use with trusted content
<div dangerouslySetInnerHTML={{ __html: trustedHtml }} />

// ✅ Good: Sanitize HTML
import DOMPurify from 'isomorphic-dompurify';

const sanitizeHtml = (dirty: string): string => {
  return DOMPurify.sanitize(dirty, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a', 'p'],
    ALLOWED_ATTR: ['href'],
  });
};

// Usage
<div dangerouslySetInnerHTML={{ __html: sanitizeHtml(userHtml) }} />
```

### Content Security Policy

```typescript
// Next.js middleware
export function middleware(request: NextRequest) {
  const response = NextResponse.next();
  
  response.headers.set(
    'Content-Security-Policy',
    "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';"
  );
  
  return response;
}
```

## SQL Injection Prevention

### Using Prisma (Recommended)

```typescript
// ✅ Good: Parameterized queries (safe)
const user = await prisma.user.findUnique({
  where: { email: userEmail },
});

// ✅ Good: Safe filtering
const users = await prisma.user.findMany({
  where: {
    name: { contains: searchTerm },
    age: { gte: minAge },
  },
});

// ❌ Avoid: Raw SQL with string concatenation
const users = await prisma.$queryRaw`
  SELECT * FROM users WHERE name = ${searchTerm}
`; // Still safe with Prisma, but prefer the ORM methods
```

### Using Raw Queries (If Necessary)

```typescript
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

## Authentication & Authorization

### Password Hashing

```typescript
import bcrypt from 'bcrypt';

// Hash password
export async function hashPassword(password: string): Promise<string> {
  const saltRounds = 12;
  return await bcrypt.hash(password, saltRounds);
}

// Verify password
export async function verifyPassword(
  password: string,
  hash: string
): Promise<boolean> {
  return await bcrypt.compare(password, hash);
}

// Usage
const hashedPassword = await hashPassword(userPassword);
await db.user.create({
  data: {
    email: user.email,
    password: hashedPassword,
  },
});
```

### JWT Tokens

```typescript
import jwt from 'jsonwebtoken';

// Generate token
export function generateToken(userId: string): string {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET!,
    { expiresIn: '15m' }
  );
}

// Generate refresh token
export function generateRefreshToken(userId: string): string {
  return jwt.sign(
    { userId, type: 'refresh' },
    process.env.JWT_REFRESH_SECRET!,
    { expiresIn: '7d' }
  );
}

// Verify token
export function verifyToken(token: string): { userId: string } {
  try {
    return jwt.verify(token, process.env.JWT_SECRET!) as { userId: string };
  } catch (error) {
    throw new Error('Invalid token');
  }
}

// Middleware
export function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }
  
  try {
    const decoded = verifyToken(token);
    req.userId = decoded.userId;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}
```

### Session Management

```typescript
// Next.js API route with session
import { getServerSession } from 'next-auth';
import { authOptions } from './auth/[...nextauth]';

export async function GET(request: Request) {
  const session = await getServerSession(authOptions);
  
  if (!session) {
    return new Response('Unauthorized', { status: 401 });
  }
  
  // User is authenticated
  return Response.json({ user: session.user });
}
```

## Environment Variables

### Best Practices

```typescript
// ✅ Good: Validate environment variables at startup
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
  API_KEY: z.string(),
  NODE_ENV: z.enum(['development', 'production', 'test']),
});

export const env = envSchema.parse(process.env);

// ❌ Never: Hardcode secrets
const apiKey = 'sk-1234567890abcdef'; // Never do this!

// ✅ Good: Use environment variables
const apiKey = process.env.API_KEY;

// ✅ Good: Type-safe environment variables
declare global {
  namespace NodeJS {
    interface ProcessEnv {
      DATABASE_URL: string;
      JWT_SECRET: string;
      API_KEY: string;
      NODE_ENV: 'development' | 'production' | 'test';
    }
  }
}
```

### Next.js Environment Variables

```typescript
// .env.local (never commit)
DATABASE_URL=postgresql://user:pass@localhost:5432/db
JWT_SECRET=your-secret-key
API_KEY=your-api-key

// .env.example (commit this)
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
JWT_SECRET=your-secret-key-here
API_KEY=your-api-key-here

// Access in Next.js
// Server-side: process.env.DATABASE_URL
// Client-side: process.env.NEXT_PUBLIC_API_URL (must be prefixed)
```

## Rate Limiting

```typescript
import rateLimit from 'express-rate-limit';

// General API rate limit
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP',
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/api/', apiLimiter);

// Stricter limit for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: 'Too many login attempts',
  skipSuccessfulRequests: true,
});

app.use('/api/auth/login', authLimiter);

// Next.js API route with rate limiting
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '10 s'),
});

export async function POST(request: Request) {
  const ip = request.headers.get('x-forwarded-for') ?? 'anonymous';
  const { success } = await ratelimit.limit(ip);
  
  if (!success) {
    return new Response('Too many requests', { status: 429 });
  }
  
  // Process request
}
```

## CORS Configuration

```typescript
import cors from 'cors';

// ✅ Good: Specific origins
const corsOptions = {
  origin: [
    'https://example.com',
    'https://app.example.com',
  ],
  credentials: true,
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));

// ❌ Avoid: Allow all origins in production
app.use(cors({ origin: '*' })); // Only for development

// Next.js API route
export async function GET(request: Request) {
  const origin = request.headers.get('origin');
  const allowedOrigins = ['https://example.com'];
  
  if (origin && allowedOrigins.includes(origin)) {
    return new Response(JSON.stringify(data), {
      headers: {
        'Access-Control-Allow-Origin': origin,
        'Access-Control-Allow-Credentials': 'true',
      },
    });
  }
  
  return new Response('Forbidden', { status: 403 });
}
```

## Secure Headers

```typescript
// Express.js with Helmet
import helmet from 'helmet';

app.use(helmet());

// Next.js middleware
export function middleware(request: NextRequest) {
  const response = NextResponse.next();
  
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('X-Frame-Options', 'DENY');
  response.headers.set('X-XSS-Protection', '1; mode=block');
  response.headers.set(
    'Strict-Transport-Security',
    'max-age=31536000; includeSubDomains'
  );
  response.headers.set(
    'Content-Security-Policy',
    "default-src 'self'; script-src 'self' 'unsafe-inline'"
  );
  
  return response;
}

// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
        ],
      },
    ];
  },
};
```

## Error Handling

```typescript
// ✅ Good: Don't expose internal details
try {
  await connectToDatabase();
} catch (error) {
  logger.error('Database connection failed', { error });
  throw new Error('Service temporarily unavailable');
}

// ❌ Bad: Exposes internal details
throw new Error(`Database connection failed: ${dbConfig.password}`);

// ✅ Good: Custom error classes
class ApiError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public isOperational = true
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

// Error handler middleware
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  if (err instanceof ApiError) {
    return res.status(err.statusCode).json({
      error: err.message,
    });
  }
  
  // Don't expose internal errors
  logger.error('Unexpected error', { error: err });
  res.status(500).json({
    error: 'Internal server error',
  });
});
```

## Security Checklist

### Pre-deployment

- [ ] All secrets in environment variables
- [ ] Input validation on all endpoints
- [ ] Output sanitization implemented
- [ ] Authentication/authorization working
- [ ] HTTPS enabled
- [ ] Security headers configured
- [ ] Rate limiting implemented
- [ ] CORS configured properly
- [ ] Dependencies updated (`npm audit`)
- [ ] No console.logs with sensitive data
- [ ] Error messages don't expose internals
- [ ] SQL injection prevention verified
- [ ] XSS prevention verified

### Regular Maintenance

- Weekly: `npm audit` and update dependencies
- Monthly: Review security advisories
- Quarterly: Security audit and penetration testing

---

**Related guides:**
- #[[file:typescript-code-conventions.md]] - TypeScript coding standards
- #[[file:typescript-testing-standards.md]] - TypeScript testing patterns
- #[[file:../security-policies.md]] - General security guidelines
