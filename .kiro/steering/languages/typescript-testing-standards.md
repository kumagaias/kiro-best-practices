---
inclusion: fileMatch
fileMatchPattern: '**/*.(test|spec).(ts|tsx|js|jsx)'
description: TypeScript/JavaScript testing standards using Vitest/Jest with examples
---

# TypeScript Testing Standards

TypeScript-specific testing patterns and best practices.

**Usage**: Automatically included when working on test files, or use `#typescript-testing-standards` in chat.

**Note**: See #[[file:../testing-standards.md]] for general testing guidelines.

---

## Recommended Stack

- **Vitest** or **Jest** - Test runner
- **React Testing Library** - Component testing
- **Playwright** - E2E testing
- **MSW** - API mocking

## Component Testing

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

  it('should call onClick handler', async () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click</Button>);
    
    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

## API Testing

```typescript
import { describe, it, expect } from 'vitest';
import request from 'supertest';
import { app } from '../app';

describe('User API', () => {
  it('should create user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'John', email: 'john@example.com' })
      .expect(201);

    expect(response.body).toMatchObject({
      id: expect.any(String),
      name: 'John',
      email: 'john@example.com',
    });
  });
});
```

## Mocking

```typescript
// Mock module
vi.mock('./api', () => ({
  fetchUser: vi.fn(),
}));

// Mock implementation
import { fetchUser } from './api';
vi.mocked(fetchUser).mockResolvedValue({ id: '1', name: 'John' });

// MSW for API mocking
import { rest } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  rest.get('/api/users/:id', (req, res, ctx) => {
    return res(ctx.json({ id: req.params.id, name: 'John' }));
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

## Async Testing

```typescript
// ✅ Good: Use async/await
it('should fetch data', async () => {
  const data = await fetchData();
  expect(data).toBeDefined();
});

// ✅ Good: Wait for element
it('should display user', async () => {
  render(<UserProfile userId="1" />);
  expect(await screen.findByText('John')).toBeInTheDocument();
});
```

## Type-Safe Mocks

```typescript
// Type-safe mock function
const mockFn = vi.fn<[string], Promise<User>>();
mockFn.mockResolvedValue({ id: '1', name: 'John' });

// Type-safe spy
const spy = vi.spyOn(api, 'fetchUser');
spy.mockResolvedValue({ id: '1', name: 'John' });
```

---

**Related guides:**
- #[[file:typescript-code-conventions.md]] - Coding standards
- #[[file:../testing-standards.md]] - General testing
