---
inclusion: always
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

### Example: Unit Test

```
describe('calculateTotal', () => {
  it('should sum item prices', () => {
    const items = [{ price: 10 }, { price: 20 }];
    expect(calculateTotal(items)).toBe(30);
  });

  it('should return 0 for empty array', () => {
    expect(calculateTotal([])).toBe(0);
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

### Example: Integration Test

```
describe('User API', () => {
  it('should create and retrieve user', async () => {
    const response = await createUser({ name: 'John' });
    expect(response.status).toBe(201);
    
    const user = await getUser(response.body.id);
    expect(user.name).toBe('John');
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

### Example: E2E Test

```
test('user can complete checkout', async () => {
  await navigateTo('/products');
  await clickAddToCart();
  await clickCheckout();
  await fillCheckoutForm();
  await submitOrder();
  
  await expectSuccessMessage();
});
```

## Testing Libraries

### General Recommendations

Choose testing libraries appropriate for your language/framework:

**JavaScript/TypeScript:**
- See #[[file:languages/testing-typescript.md]] for detailed setup

**Python:**
- pytest, unittest
- See language-specific guide (coming soon)

**Go:**
- testing package, testify
- See language-specific guide (coming soon)

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

```
describe('ComponentName', () => {
  beforeEach(() => {
    // Setup
  });

  afterEach(() => {
    // Cleanup
  });

  describe('feature group', () => {
    it('should behave correctly', () => {
      // Arrange
      const input = setupInput();
      
      // Act
      const result = performAction(input);
      
      // Assert
      expect(result).toBe(expected);
    });
  });
});
```

## Mocking Strategies

**See language-specific guides for detailed mocking patterns:**
- #[[file:languages/testing-typescript.md]] - TypeScript/JavaScript mocking

### General Principles

- Mock external dependencies
- Use dependency injection when possible
- Keep mocks simple
- Verify mock interactions

## Assertion Styles

### Preferred Patterns

```
// ✅ Good: Clear and specific
expect(result).toBe(42);
expect(user.name).toBe('John');
expect(items).toHaveLength(3);

// ❌ Avoid: Vague
expect(result).toBeTruthy();
```

### Common Assertions

- Equality: `toBe()`, `toEqual()`
- Truthiness: `toBeTruthy()`, `toBeFalsy()`, `toBeNull()`
- Numbers: `toBeGreaterThan()`, `toBeLessThan()`
- Strings: `toContain()`, `toMatch()`
- Arrays: `toHaveLength()`, `toContain()`
- Functions: `toHaveBeenCalled()`, `toHaveBeenCalledWith()`
- Async: `resolves.toBe()`, `rejects.toThrow()`

## Test Data Management

### Test Fixtures

Create reusable test data:

```
// fixtures/users
export const mockUser = {
  id: '1',
  name: 'John Doe',
  email: 'john@example.com',
};
```

### Factory Functions

Generate test data dynamically:

```
export const createUser = (overrides = {}) => ({
  id: generateId(),
  name: 'Test User',
  email: 'test@example.com',
  ...overrides,
});
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

```
// Print debug information
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
- #[[file:deployment-workflow.md]] - Testing requirements and coverage targets
- #[[file:languages/testing-typescript.md]] - TypeScript testing patterns
- #[[file:security-policies.md]] - Security testing considerations
