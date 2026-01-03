---
inclusion: fileMatch
fileMatchPattern: '**/*.(test|spec).(ts|tsx|js|jsx)'
---

# TypeScript Testing Standards

TypeScript-specific testing patterns, libraries, and best practices.

**Usage**: Automatically included when working on test files, or use `#typescript-testing-standards` in chat.

---

## Testing Libraries

### Recommended Stack

**Unit/Integration Testing:**
- **Vitest** - Fast test runner with TypeScript support
- **Jest** - Alternative test runner
- **React Testing Library** - Component testing
- **Supertest** - API testing

**E2E Testing:**
- **Playwright** - Browser automation with TypeScript

**Mocking:**
- **MSW** (Mock Service Worker) - API mocking
- **vi.mock()** or **jest.mock()** - Module mocking

### Installation

```bash
# Vitest + React Testing Library
npm install -D vitest @testing-library/react @testing-library/jest-dom
npm install -D @testing-library/user-event

# Playwright
npm install -D @playwright/test

# MSW
npm install -D msw

# Type definitions
npm install -D @types/jest @types/node
```

### Configuration

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: './src/test/setup.ts',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: ['node_modules/', 'src/test/'],
    },
  },
});
```

## TypeScript Test Patterns

### Type-Safe Test Setup

```typescript
// src/test/setup.ts
import { expect, afterEach } from 'vitest';
import { cleanup } from '@testing-library/react';
import * as matchers from '@testing-library/jest-dom/matchers';

expect.extend(matchers);

afterEach(() => {
  cleanup();
});
```

### Component Testing

```typescript
import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './Button';

describe('Button', () => {
  it('should render with correct text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button')).toHaveTextContent('Click me');
  });

  it('should call onClick with correct type', async () => {
    const handleClick = vi.fn<[React.MouseEvent<HTMLButtonElement>], void>();
    render(<Button onClick={handleClick}>Click</Button>);
    
    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('should accept generic props', () => {
    interface CustomProps {
      variant: 'primary' | 'secondary';
    }
    
    const CustomButton = (props: CustomProps) => <Button {...props} />;
    render(<CustomButton variant="primary">Test</CustomButton>);
    expect(screen.getByRole('button')).toBeInTheDocument();
  });
});
```

### API Testing with Types

```typescript
import { describe, it, expect } from 'vitest';
import request from 'supertest';
import { app } from '../app';

interface User {
  id: string;
  name: string;
  email: string;
}

describe('User API', () => {
  it('should create user with correct types', async () => {
    const userData = {
      name: 'John Doe',
      email: 'john@example.com',
    };

    const response = await request(app)
      .post('/api/users')
      .send(userData)
      .expect(201);

    const user: User = response.body;
    expect(user).toMatchObject({
      id: expect.any(String),
      name: userData.name,
      email: userData.email,
    });
  });
});
```

### Mocking with Types

```typescript
import { vi } from 'vitest';

// Type-safe module mock
vi.mock('./api', () => ({
  fetchUser: vi.fn<[string], Promise<User>>(),
  updateUser: vi.fn<[string, Partial<User>], Promise<User>>(),
}));

import { fetchUser, updateUser } from './api';

// Type-safe mock implementation
vi.mocked(fetchUser).mockResolvedValue({
  id: '1',
  name: 'John',
  email: 'john@example.com',
});

// Type-safe assertion
expect(fetchUser).toHaveBeenCalledWith('1');
```

### MSW with TypeScript

```typescript
import { rest } from 'msw';
import { setupServer } from 'msw/node';

interface ApiUser {
  id: string;
  name: string;
  email: string;
}

const handlers = [
  rest.get<never, { id: string }, ApiUser>(
    '/api/users/:id',
    (req, res, ctx) => {
      return res(
        ctx.json({
          id: req.params.id,
          name: 'John Doe',
          email: 'john@example.com',
        })
      );
    }
  ),

  rest.post<Partial<ApiUser>, never, ApiUser>(
    '/api/users',
    async (req, res, ctx) => {
      const body = await req.json();
      return res(
        ctx.status(201),
        ctx.json({
          id: '1',
          ...body,
        } as ApiUser)
      );
    }
  ),
];

export const server = setupServer(...handlers);
```

## Type-Safe Test Utilities

### Custom Render Function

```typescript
import { render, RenderOptions } from '@testing-library/react';
import { ReactElement } from 'react';
import { ThemeProvider } from './ThemeProvider';

interface CustomRenderOptions extends Omit<RenderOptions, 'wrapper'> {
  theme?: 'light' | 'dark';
}

export const customRender = (
  ui: ReactElement,
  options?: CustomRenderOptions
) => {
  const { theme = 'light', ...renderOptions } = options || {};

  const Wrapper = ({ children }: { children: React.ReactNode }) => (
    <ThemeProvider theme={theme}>{children}</ThemeProvider>
  );

  return render(ui, { wrapper: Wrapper, ...renderOptions });
};
```

### Type-Safe Factories

```typescript
import { faker } from '@faker-js/faker';

export const createUser = (overrides?: Partial<User>): User => ({
  id: faker.string.uuid(),
  name: faker.person.fullName(),
  email: faker.internet.email(),
  createdAt: faker.date.past(),
  ...overrides,
});

export const createUsers = (count: number, overrides?: Partial<User>): User[] =>
  Array.from({ length: count }, () => createUser(overrides));
```

## Async Testing

### Testing Promises

```typescript
it('should handle async operations', async () => {
  const promise = fetchUser('1');
  
  // Type-safe promise assertion
  await expect(promise).resolves.toMatchObject({
    id: '1',
    name: expect.any(String),
  });
});

it('should handle errors', async () => {
  const promise = fetchUser('invalid');
  
  await expect(promise).rejects.toThrow('User not found');
});
```

### Testing React Query

```typescript
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { renderHook, waitFor } from '@testing-library/react';
import { useUser } from './useUser';

const createWrapper = () => {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  });

  return ({ children }: { children: React.ReactNode }) => (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  );
};

it('should fetch user data', async () => {
  const { result } = renderHook(() => useUser('1'), {
    wrapper: createWrapper(),
  });

  await waitFor(() => expect(result.current.isSuccess).toBe(true));
  
  expect(result.current.data).toMatchObject({
    id: '1',
    name: expect.any(String),
  });
});
```

## Testing Best Practices

### Type Assertions

```typescript
// ✅ Good: Type-safe assertions
expect(user).toMatchObject<Partial<User>>({
  name: 'John',
  email: 'john@example.com',
});

// ✅ Good: Use type guards
function isUser(value: unknown): value is User {
  return (
    typeof value === 'object' &&
    value !== null &&
    'id' in value &&
    'name' in value
  );
}

expect(isUser(result)).toBe(true);

// ❌ Avoid: Type assertions in tests
expect((result as User).name).toBe('John');
```

### Generic Test Utilities

```typescript
// Type-safe test helper
export const expectType = <T>() => ({
  toMatch: (value: T) => value,
  notToMatch: (value: any) => {
    // Type error if value matches T
    const _: Exclude<typeof value, T> = value;
  },
});

// Usage
it('should have correct type', () => {
  const user = createUser();
  expectType<User>().toMatch(user);
});
```

## Configuration Files

### tsconfig.json for Tests

```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "types": ["vitest/globals", "@testing-library/jest-dom"]
  },
  "include": ["src/**/*.test.ts", "src/**/*.test.tsx", "src/test/**/*"]
}
```

### ESLint for Tests

```json
{
  "overrides": [
    {
      "files": ["**/*.test.ts", "**/*.test.tsx"],
      "rules": {
        "@typescript-eslint/no-explicit-any": "off",
        "@typescript-eslint/no-non-null-assertion": "off"
      }
    }
  ]
}
```

---

**Related guides:**
- #[[file:../testing-standards.md]] - General testing standards
- #[[file:typescript-code-conventions.md]] - TypeScript coding standards
- #[[file:typescript-security-policies.md]] - TypeScript security practices
- #[[file:../security-policies.md]] - Security testing considerations
