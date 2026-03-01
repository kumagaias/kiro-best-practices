---
inclusion: always
description: Core testing principles, coverage targets, and test types overview
---

# Testing Standards

Core testing principles and requirements for ensuring code quality.

---

## Testing Philosophy

- Write tests before fixing bugs
- Test behavior, not implementation
- Keep tests simple and readable
- Tests should be independent
- Fast feedback is critical

## Coverage Targets

- **Overall**: 60% or higher
- **Critical paths**: 80% or higher
- **New code**: 80% or higher
- **Bug fixes**: Must include regression tests

## Test Types

### Unit Tests
Test individual functions/components in isolation.
- Fast (< 1ms per test)
- No external dependencies
- Use mocks/stubs

### Integration Tests
Test multiple components working together.
- Slower than unit tests
- May use real dependencies
- Verify data flow

### E2E Tests
Test complete user workflows.
- Slowest tests
- Use real browser/environment
- Test critical user paths

## Test Organization

### Arrange-Act-Assert (AAA) Pattern
1. **Arrange**: Set up test data and conditions
2. **Act**: Execute the code being tested
3. **Assert**: Verify the results

## Best Practices

### Do's
- ✅ Test behavior, not implementation
- ✅ Use descriptive test names
- ✅ One assertion per test (when possible)
- ✅ Test edge cases and error conditions
- ✅ Keep tests independent

### Don'ts
- ❌ Test private methods directly
- ❌ Rely on test execution order
- ❌ Use real external services
- ❌ Share state between tests
- ❌ Write flaky tests

## Running Tests

```bash
make test              # All tests
make test-unit         # Unit tests only
make test -- --coverage # With coverage
```

---

**For detailed testing patterns and examples:**
- #[[file:testing-patterns.md]] - Advanced testing patterns and strategies
- #[[file:skills/typescript-testing-standards.md]] - TypeScript/JavaScript testing

**Related guides:**
- #[[file:deployment-workflow.md]] - Testing requirements
- #[[file:security-policies.md]] - Security testing
