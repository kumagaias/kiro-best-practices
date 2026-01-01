---
inclusion: manual
---

# Testing Standards

Testing approach, patterns, and best practices for ensuring code quality.

**Usage**: Include this guide by typing `#testing-standards` in chat or when working on tests.

---

## Testing Philosophy

- Write tests before fixing bugs
- Test behavior, not implementation
- Keep tests simple and readable
- Tests should be independent
- Fast feedback is critical

## Coverage Expectations

### Coverage Targets

- **Overall**: 60% or higher
- **Critical paths**: 80% or higher
- **New code**: 80% or higher
- **Bug fixes**: Must include regression tests

### What to Test

**High Priority:**
- Business logic
- Data transformations
- Error handling
- Edge cases
- Security-critical code

**Medium Priority:**
- API endpoints
- Database queries
- Integration points
- User interactions

**Low Priority:**
- Simple getters/setters
- Configuration files
- Third-party library wrappers

## Test Types

### Unit Tests

Test individual functions/components in isolation.

**Characteristics:**
- Fast (< 1ms per test)
- No external dependencies
- Use mocks/stubs
- Test one thing at a time

**Example:**
```typescript
describe('calculateTotal', () => {
  it('should sum item prices', () => {
    const items = [
      { price: 10 },
      { price: 20 },
      { price: 30 },
    ];
    expect(calculateTotal(items)).toBe(60);
  });

  it('should return 0 for empty array', () => {
    expect(calculateTotal([])).toBe(0);
  });

  it('should handle negative prices', () => {
    const items = [{ price: -10 }];
    expect(calculateTotal(items)).toBe(-10);
  });
});
```

### Integration Tests

Test multiple components working together.

**Characteristics:**
- Slower than unit tests
- May use real dependencies
- Test component interactions
- Verify data flow

**Example:**
```typescript
describe('User API', () => {
  it('should create and retrieve user', async () => {
    // Create user
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'John', email: 'john@example.com' });
    
    expect(response.status).toBe(201);
    const userId = response.body.id;

    // Retrieve user
    const getResponse = await request(app)
      .get(`/api/users/${userId}`);
    
    expect(getResponse.status).toBe(200);
    expect(getResponse.body.name).toBe('John');
  });
});
```

### E2E Tests

Test complete user workflows.

**Characteristics:**
- Slowest tests
- Use real browser/environment
- Test critical user paths
- Run less frequently

**Example:**
```typescript
test('user can complete checkout', async ({ page }) => {
  await page.goto('/products');
  await page.click('[data-testid="add-to-cart"]');
  await page.click('[data-testid="checkout"]');
  await page.fill('[name="email"]', 'user@example.com');
  await page.fill('[name="card"]', '4242424242424242');
  await page.click('[data-testid="submit-order"]');
  
  await expect(page.locator('[data-testid="success-message"]'))
    .toBeVisible();
});
```

## Testing Libraries

### Recommended Stack

**Unit/Integration Testing:**
- **Jest** or **Vitest** - Test runner
- **React Testing Library** - Component testing
- **Supertest** - API testing

**E2E Testing:**
- **Playwright** - Browser automation

**Mocking:**
- **MSW** (Mock Service Worker) - API mocking
- **jest.mock()** or **vi.mock()** - Module mocking

### Library Setup

```bash
# Install testing dependencies
npm install -D vitest @testing-library/react @testing-library/jest-dom
npm install -D @playwright/test
npm install -D msw
```

## Test Organization

### File Structure

```
src/
├── components/
│   ├── Button.tsx
│   └── Button.test.tsx          # Co-located with component
├── utils/
│   ├── formatters.ts
│   └── formatters.test.ts       # Co-located with utility
└── __tests__/
    ├── integration/
    │   └── api.test.ts          # Integration tests
    └── e2e/
        └── checkout.spec.ts     # E2E tests
```

### Naming Conventions

- Unit/Integration: `*.test.ts` or `*.spec.ts`
- E2E: `*.spec.ts` (in separate directory)
- Test suites: Use `describe()` blocks
- Test cases: Use `it()` or `test()`

### Test File Template

```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { render, screen } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  beforeEach(() => {
    // Setup before each test
  });

  afterEach(() => {
    // Cleanup after each test
  });

  describe('rendering', () => {
    it('should render with text', () => {
      render(<Button>Click me</Button>);
      expect(screen.getByText('Click me')).toBeInTheDocument();
    });

    it('should apply custom className', () => {
      render(<Button className="custom">Click</Button>);
      expect(screen.getByRole('button')).toHaveClass('custom');
    });
  });

  describe('interactions', () => {
    it('should call onClick when clicked', () => {
      const handleClick = vi.fn();
      render(<Button onClick={handleClick}>Click</Button>);
      
      screen.getByRole('button').click();
      expect(handleClick).toHaveBeenCalledTimes(1);
    });
  });

  describe('states', () => {
    it('should be disabled when disabled prop is true', () => {
      render(<Button disabled>Click</Button>);
      expect(screen.getByRole('button')).toBeDisabled();
    });
  });
});
```

## Mocking Strategies

### Module Mocking

```typescript
// Mock entire module
vi.mock('./api', () => ({
  fetchUser: vi.fn(),
}));

// Mock specific function
import { fetchUser } from './api';
vi.mocked(fetchUser).mockResolvedValue({ id: 1, name: 'John' });
```

### API Mocking with MSW

```typescript
import { rest } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  rest.get('/api/users/:id', (req, res, ctx) => {
    return res(
      ctx.json({ id: req.params.id, name: 'John' })
    );
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

### Dependency Injection

```typescript
// Instead of mocking, inject dependencies
class UserService {
  constructor(private api: ApiClient) {}
  
  async getUser(id: string) {
    return this.api.get(`/users/${id}`);
  }
}

// In tests, inject mock
const mockApi = { get: vi.fn() };
const service = new UserService(mockApi);
```

## Assertion Styles

### Preferred Patterns

```typescript
// ✅ Good: Clear and specific
expect(result).toBe(42);
expect(user.name).toBe('John');
expect(items).toHaveLength(3);
expect(element).toBeInTheDocument();

// ❌ Avoid: Vague or complex
expect(result).toBeTruthy();
expect(JSON.stringify(user)).toBe('{"name":"John"}');
```

### Common Assertions

```typescript
// Equality
expect(value).toBe(expected);           // Strict equality
expect(value).toEqual(expected);        // Deep equality

// Truthiness
expect(value).toBeTruthy();
expect(value).toBeFalsy();
expect(value).toBeNull();
expect(value).toBeUndefined();

// Numbers
expect(value).toBeGreaterThan(10);
expect(value).toBeLessThanOrEqual(100);
expect(value).toBeCloseTo(0.3, 1);      // Floating point

// Strings
expect(text).toContain('substring');
expect(text).toMatch(/pattern/);

// Arrays
expect(array).toHaveLength(3);
expect(array).toContain(item);
expect(array).toEqual(expect.arrayContaining([1, 2]));

// Objects
expect(obj).toHaveProperty('key');
expect(obj).toMatchObject({ key: 'value' });

// Functions
expect(fn).toHaveBeenCalled();
expect(fn).toHaveBeenCalledWith(arg1, arg2);
expect(fn).toHaveBeenCalledTimes(2);

// Async
await expect(promise).resolves.toBe(value);
await expect(promise).rejects.toThrow(Error);
```

## Test Data Management

### Test Fixtures

```typescript
// fixtures/users.ts
export const mockUser = {
  id: '1',
  name: 'John Doe',
  email: 'john@example.com',
};

export const mockUsers = [
  mockUser,
  { id: '2', name: 'Jane Doe', email: 'jane@example.com' },
];
```

### Factory Functions

```typescript
// factories/user.ts
export const createUser = (overrides = {}) => ({
  id: Math.random().toString(),
  name: 'Test User',
  email: 'test@example.com',
  createdAt: new Date(),
  ...overrides,
});

// Usage
const user = createUser({ name: 'Custom Name' });
```

## Best Practices

### Do's

- ✅ Test behavior, not implementation
- ✅ Use descriptive test names
- ✅ Arrange-Act-Assert pattern
- ✅ One assertion per test (when possible)
- ✅ Test edge cases and error conditions
- ✅ Keep tests independent
- ✅ Use meaningful variable names
- ✅ Clean up after tests

### Don'ts

- ❌ Test private methods directly
- ❌ Rely on test execution order
- ❌ Use real external services
- ❌ Share state between tests
- ❌ Write flaky tests
- ❌ Test framework code
- ❌ Duplicate production code in tests

## Running Tests

### Commands

```bash
# Run all tests
make test

# Run unit tests only
make test-unit

# Run with coverage
npm test -- --coverage

# Run specific file
npm test -- Button.test.ts

# Run in watch mode (development)
npm test -- --watch

# Run E2E tests
npm run test:e2e
```

### CI/CD Integration

```yaml
# .github/workflows/test.yml
- name: Run tests
  run: |
    npm ci
    npm test -- --coverage
    
- name: Upload coverage
  uses: codecov/codecov-action@v3
```

## Debugging Tests

### Debug Strategies

```typescript
// Print component output
import { screen, debug } from '@testing-library/react';
debug(); // Prints entire DOM
debug(screen.getByRole('button')); // Prints specific element

// Use console.log
console.log('Value:', value);

// Use debugger
debugger; // Pauses execution

// Run single test
it.only('should work', () => {
  // Only this test runs
});

// Skip test
it.skip('should work', () => {
  // This test is skipped
});
```

## Performance

### Test Speed Guidelines

- Unit tests: < 1ms each
- Integration tests: < 100ms each
- E2E tests: < 5s each

### Optimization Tips

- Use `beforeAll` for expensive setup
- Mock external dependencies
- Parallelize test execution
- Use test.concurrent for independent tests
- Avoid unnecessary renders/re-renders

---

**Related guides:**
- #[[file:project.md]] - Testing requirements and coverage targets
- #[[file:tech-typescript.md]] - TypeScript-specific testing patterns
- #[[file:security-policies.md]] - Security testing considerations
