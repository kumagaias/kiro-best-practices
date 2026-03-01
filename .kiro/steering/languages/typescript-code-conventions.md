---
inclusion: fileMatch
fileMatchPattern: '**/*.(ts|tsx|js|jsx)'
description: TypeScript/JavaScript coding standards including naming conventions, type safety, and best practices
---

# TypeScript Code Conventions

TypeScript/JavaScript coding standards and best practices.

**Usage**: Automatically included when working on TypeScript files, or use `#typescript-code-conventions` in chat.

---

## Naming Conventions

- **Variables/Functions**: camelCase (`userName`, `fetchData`)
- **Classes/Components**: PascalCase (`UserProfile`, `Button`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRY_COUNT`)
- **Booleans**: Prefix with `is`, `has`, `should` (`isLoading`, `hasPermission`)
- **Event Handlers**: Prefix with `handle` (`handleClick`, `handleSubmit`)
- **Private Members**: Prefix with `_` (`_privateMethod`)

**Files**:
- Components: PascalCase (`Button.tsx`)
- Utilities: camelCase (`formatDate.ts`)
- Tests: Add `.test` or `.spec` (`Button.test.tsx`)

## Type Safety

- Prefer `interface` over `type` for public APIs
- Specify explicit return types for exported functions
- Avoid `any` (use `unknown` if needed)
- Use type guards for runtime checks

```typescript
// ✅ Good
export function getUser(id: string): Promise<User> {
  return api.get(`/users/${id}`);
}

function isUser(value: unknown): value is User {
  return typeof value === 'object' && value !== null && 'id' in value;
}
```

## Code Style

- Use semicolons
- Single quotes (except JSX uses double quotes)
- 2 spaces indentation
- Max 100 characters per line
- Use destructuring and template literals
- Prefer arrow functions for callbacks

```typescript
// ✅ Good
const { name, email } = user;
const message = `Hello, ${name}!`;
const handleClick = () => console.log('Clicked');
```

## Error Handling

```typescript
// ✅ Good
async function fetchUser(id: string): Promise<User> {
  try {
    const response = await api.get(`/users/${id}`);
    return response.data;
  } catch (error) {
    logger.error('Failed to fetch user', { userId: id, error });
    throw new Error('Unable to fetch user data');
  }
}
```

## Performance

**Frontend**: Use SSR/SSG, optimize images, code splitting, memoize with `useMemo`/`useCallback`

**Backend**: Optimize queries, use `Promise.all` for parallel processing, implement caching

```typescript
// ✅ Parallel processing
const [users, posts] = await Promise.all([fetchUsers(), fetchPosts()]);
```

## Prohibited Practices

- ❌ Excessive `any` type usage
- ❌ Missing error handling
- ❌ Console logs in production
- ❌ Files > 500 lines
- ❌ Deeply nested code (> 3 levels)
- ❌ N+1 query problems

---

**Related guides:**
- #[[file:typescript-testing-standards.md]] - Testing patterns
- #[[file:typescript-security-policies.md]] - Security practices
- #[[file:../testing-standards.md]] - General testing
- #[[file:../security-policies.md]] - General security
