---
inclusion: fileMatch
fileMatchPattern: '**/*.(ts|tsx|js|jsx)'
---

# TypeScript Code Conventions

TypeScript/JavaScript coding standards, naming conventions, and best practices.

**Usage**: Automatically included when working on TypeScript files, or use `#typescript-code-conventions` in chat.

---

## Project Setup

### Quick Start (Existing Project)

```bash
# 1. Clone repository
git clone <repository-url>
cd <project-name>

# 2. Install dependencies
npm ci
cd frontend && npm ci && cd ..
cd backend && npm ci && cd ..

# 3. Configure environment variables (if needed)
cp frontend/.env.local.example frontend/.env.local
cp backend/.env.local.example backend/.env.local

# 4. Run tests to verify setup
make test
```

### New Project Setup

```bash
# Create project directories
mkdir -p frontend backend infra docs scripts

# Copy package.json templates
cp <template-project>/package.json .
cp <template-project>/frontend/package.json frontend/
cp <template-project>/backend/package.json backend/

# Install dependencies
npm install
cd frontend && npm install && cd ..
cd backend && npm install && cd ..
```

### Tool Installation

```bash
# Node.js (via nvm or asdf)
nvm install 24  # or version in .tool-versions
nvm use 24

# Make (usually pre-installed)
make --version
```

## Naming Conventions

### Variables and Functions
- **Variables/Functions**: camelCase (`userName`, `fetchData`)
- **Classes/Components**: PascalCase (`UserProfile`, `Button`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRY_COUNT`)
- **Booleans**: Prefix with `is`, `has`, `should` (`isLoading`, `hasPermission`)
- **Event Handlers**: Prefix with `handle` (`handleClick`, `handleSubmit`)
- **Private Members**: Prefix with `_` (`_privateMethod`)

### Files and Directories
- **Components**: PascalCase (`Button.tsx`, `UserProfile.tsx`)
- **Utilities**: camelCase (`formatDate.ts`, `apiClient.ts`)
- **Tests**: Same as source with `.test` or `.spec` (`Button.test.tsx`)
- **Types**: PascalCase (`UserType.ts`, `ApiResponse.ts`)

## TypeScript Best Practices

### Type Safety
- Prefer `interface` over `type` for public APIs
- Specify explicit return types for exported functions
- Avoid `any` type (use `unknown` if needed)
- Minimize type assertions (`as`)
- Use type guards for runtime checks

```typescript
// ✅ Good: Explicit return type
export function getUser(id: string): Promise<User> {
  return api.get(`/users/${id}`);
}

// ✅ Good: Type guard
function isUser(value: unknown): value is User {
  return (
    typeof value === 'object' &&
    value !== null &&
    'id' in value &&
    'name' in value
  );
}

// ❌ Avoid: any type
function processData(data: any) { }

// ✅ Better: unknown with type guard
function processData(data: unknown) {
  if (isUser(data)) {
    // data is User here
  }
}
```

### Modern TypeScript Features
- Use optional chaining (`?.`)
- Use nullish coalescing (`??`)
- Use template literal types
- Use const assertions

```typescript
// Optional chaining
const userName = user?.profile?.name;

// Nullish coalescing
const displayName = userName ?? 'Anonymous';

// Const assertion
const config = {
  apiUrl: 'https://api.example.com',
  timeout: 5000,
} as const;
```

## Coding Style

### Formatting
- Use semicolons
- Single quotes (`'`) except in JSX (use double quotes)
- 2 spaces indentation
- Max 100 characters per line
- Trailing commas in multiline

### Code Organization
- Prefer arrow functions for callbacks
- Use destructuring
- Use template literals for string interpolation
- One component per file
- Group imports (external, internal, types)

```typescript
// ✅ Good: Organized imports
import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';

import { Button } from '@/components/Button';
import { formatDate } from '@/utils/formatDate';

import type { User } from '@/types/User';

// ✅ Good: Destructuring
const { name, email } = user;

// ✅ Good: Template literals
const message = `Hello, ${name}!`;

// ✅ Good: Arrow function
const handleClick = () => {
  console.log('Clicked');
};
```

## Error Handling

### Best Practices
- Always handle errors
- Use try-catch for async operations
- Provide meaningful error messages
- Log errors appropriately
- Don't expose sensitive information

```typescript
// ✅ Good: Proper error handling
async function fetchUser(id: string): Promise<User> {
  try {
    const response = await api.get(`/users/${id}`);
    return response.data;
  } catch (error) {
    logger.error('Failed to fetch user', { userId: id, error });
    throw new Error('Unable to fetch user data');
  }
}

// ✅ Good: Custom error types
class ValidationError extends Error {
  constructor(
    message: string,
    public field: string,
    public value: unknown
  ) {
    super(message);
    this.name = 'ValidationError';
  }
}
```

## Logging

```typescript
const logger = {
  info: (message: string, meta?: object) => {
    console.log(JSON.stringify({ level: 'info', message, ...meta }));
  },
  error: (message: string, error?: Error, meta?: object) => {
    console.error(JSON.stringify({ 
      level: 'error', 
      message, 
      error: error?.message,
      stack: error?.stack,
      ...meta 
    }));
  },
  warn: (message: string, meta?: object) => {
    console.warn(JSON.stringify({ level: 'warn', message, ...meta }));
  },
};

// Usage
logger.info('User logged in', { userId: user.id });
logger.error('Database connection failed', error, { retryCount: 3 });
```

## Performance

### Frontend
- Use SSR/SSG appropriately
- Optimize images (Next.js Image component)
- Code splitting (dynamic imports)
- Lazy load components
- Memoize expensive computations (`useMemo`, `useCallback`)
- Avoid unnecessary re-renders

```typescript
// ✅ Good: Memoization
const expensiveValue = useMemo(() => {
  return computeExpensiveValue(data);
}, [data]);

// ✅ Good: Callback memoization
const handleClick = useCallback(() => {
  doSomething(id);
}, [id]);

// ✅ Good: Dynamic import
const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  loading: () => <Spinner />,
});
```

### Backend
- Query optimization (select only needed fields)
- Parallel processing (`Promise.all`)
- Caching strategies (Redis, in-memory)
- Connection pooling
- Batch operations

```typescript
// ✅ Good: Parallel processing
const [users, posts, comments] = await Promise.all([
  fetchUsers(),
  fetchPosts(),
  fetchComments(),
]);

// ✅ Good: Batch operations
await db.user.createMany({
  data: users,
});
```

## Prohibited Practices

### Code Quality
- ❌ Excessive use of `any` type
- ❌ Omitting error handling
- ❌ Console logs in production code
- ❌ Large files (> 500 lines per file)
- ❌ Deeply nested code (> 3 levels)
- ❌ Magic numbers (use named constants)

### Performance
- ❌ Unlimited data fetching (implement pagination)
- ❌ Synchronous mass API calls (use batching)
- ❌ N+1 query problems
- ❌ Unnecessary re-renders

## Code Review Best Practices

### Common Issues to Address

1. **Error Messages**: Include HTTP status and specific details
2. **useEffect Dependencies**: Include all used variables/functions
3. **Hardcoded Text**: Use i18n translation keys
4. **Input Validation**: Validate at function start with clear errors
5. **Empty Data Handling**: Check before processing, provide fallback UI
6. **Accessibility**: Always provide alt text fallbacks
7. **Performance**: Use `useMemo` for expensive operations
8. **Type Safety**: Avoid `any`, use proper types

### Response Priority

- **High**: Security, error handling, accessibility, type safety
- **Medium**: Performance, code organization, i18n
- **Low**: Code duplication, nitpicks, formatting

### When to Refactor

- **3+ duplications**: Extract to utility function
- **2 or fewer**: Leave as is (avoid over-abstraction)
- **Complex logic**: Extract to separate function
- **Large components**: Split into smaller components

### Review Checklist

- [ ] Types are properly defined
- [ ] Error handling is implemented
- [ ] Tests are included
- [ ] No console.logs in production code
- [ ] Accessibility attributes are present
- [ ] Performance considerations addressed
- [ ] Code follows naming conventions
- [ ] No hardcoded values

---

**Related guides:**
- #[[file:typescript-testing-standards.md]] - TypeScript testing patterns
- #[[file:typescript-security-policies.md]] - TypeScript security practices
- #[[file:../testing-standards.md]] - General testing standards
- #[[file:../security-policies.md]] - General security guidelines
