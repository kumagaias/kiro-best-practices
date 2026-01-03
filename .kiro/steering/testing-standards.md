---
inclusion: manual
---

# Testing Standards

Testing approach, patterns, and best practices for ensuring code quality.

**Usage**: Include this guide by typing `#[[file:testing-standards.md]]` in chat or when working on tests.

**Inclusion Behavior:**
- **`inclusion: always`** - Automatically included (e.g., `tech.md`)
- **`inclusion: manual`** - Only when referenced with `#[[file:...]]` (this file)
- **`fileMatchPattern`** - Auto-included when file pattern matches (e.g., `.test.ts` files)

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

**For language-specific examples:**
- #[[file:languages/typescript-testing-standards.md]] - TypeScript/JavaScript unit test examples
- Python: pytest examples (coming soon)
- Go: testing package examples (coming soon)

### Integration Tests

Test multiple components working together.

**Characteristics:**
- Slower than unit tests
- May use real dependencies
- Test component interactions
- Verify data flow

**For language-specific examples:**
- #[[file:languages/typescript-testing-standards.md]] - TypeScript/JavaScript integration test examples
- Python: pytest integration examples (coming soon)
- Go: integration test examples (coming soon)

### E2E Tests

Test complete user workflows.

**Characteristics:**
- Slowest tests
- Use real browser/environment
- Test critical user paths
- Run less frequently

**For language-specific examples:**
- #[[file:languages/typescript-testing-standards.md]] - TypeScript/JavaScript E2E test examples (Playwright)
- Python: Selenium examples (coming soon)
- Go: E2E test examples (coming soon)

## Testing Libraries

### General Recommendations

Choose testing libraries appropriate for your language/framework:

**JavaScript/TypeScript:**
- See #[[file:languages/typescript-testing-standards.md]] for detailed setup

**Python:**
- pytest, unittest
- See language-specific guide (coming soon)

**Go:**
- testing package, testify
- See language-specific guide (coming soon)

## Test Organization

### File Structure

**General Pattern:**
- Co-locate unit tests with source files
- Separate integration and E2E tests into dedicated directories
- Use consistent naming conventions

**For language-specific structures:**
- #[[file:languages/typescript-testing-standards.md]] - TypeScript/JavaScript project structure

### Naming Conventions

**General Guidelines:**
- Use clear, descriptive test file names
- Match test file names to source file names
- Group related tests together
- Use consistent suffixes (`.test`, `.spec`, `_test`, etc.)

**For language-specific conventions:**
- #[[file:languages/typescript-testing-standards.md]] - TypeScript/JavaScript naming (`.test.ts`, `.spec.ts`)
- Python: `test_*.py` or `*_test.py`
- Go: `*_test.go`

### Test Structure Pattern

**Arrange-Act-Assert (AAA) Pattern:**
1. **Arrange**: Set up test data and conditions
2. **Act**: Execute the code being tested
3. **Assert**: Verify the results

**Setup and Teardown:**
- Use setup hooks for common initialization
- Use teardown hooks for cleanup
- Keep setup minimal and focused

**For language-specific templates:**
- #[[file:languages/typescript-testing-standards.md]] - TypeScript/JavaScript test templates
- Python: pytest fixture examples (coming soon)
- Go: test function examples (coming soon)

## Mocking Strategies

**See language-specific guides for detailed mocking patterns:**
- #[[file:languages/typescript-testing-standards.md]] - TypeScript/JavaScript mocking

### General Principles

- Mock external dependencies
- Use dependency injection when possible
- Keep mocks simple
- Verify mock interactions

## Assertion Styles

### Assertion Principles

**Best Practices:**
- ✅ Use specific assertions over generic ones
- ✅ Assert on exact values when possible
- ✅ Test both success and failure cases
- ❌ Avoid vague assertions (e.g., "truthy" checks)

**Common Assertion Types:**
- **Equality**: Exact match vs deep equality
- **Truthiness**: Boolean checks, null/undefined checks
- **Comparisons**: Greater than, less than, ranges
- **Strings**: Contains, matches pattern
- **Collections**: Length, contains element
- **Functions**: Called, called with arguments
- **Async**: Resolves, rejects, throws

**For language-specific assertion APIs:**
- #[[file:languages/typescript-testing-standards.md]] - Jest/Vitest assertion examples

## Test Data Management

### Test Fixtures

**Best Practices:**
- Create reusable test data in dedicated files
- Use realistic but minimal data
- Avoid coupling fixtures to specific tests
- Version control fixture files

### Factory Functions

**Best Practices:**
- Generate test data dynamically
- Support overrides for flexibility
- Use libraries like Faker for realistic data
- Keep factories simple and focused

**For language-specific examples:**
- #[[file:languages/typescript-testing-standards.md]] - TypeScript factory patterns

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
make test -- --coverage

# Run specific file
make test -- path/to/test

# Run in watch mode (development)
make test -- --watch

# Run E2E tests
make test:e2e
```

**For language-specific commands:**
- #[[file:languages/typescript-testing-standards.md]] - npm/Vitest/Jest commands

### CI/CD Integration

```yaml
# Example: GitHub Actions
- name: Run tests
  run: make test
    
- name: Upload coverage
  uses: codecov/codecov-action@v3
```

**For language-specific CI/CD:**
- #[[file:languages/typescript-testing-standards.md]] - Node.js CI/CD examples

## Debugging Tests

### Debug Strategies

**General Techniques:**
- Print debug information to console
- Use debugger/breakpoints
- Run single test in isolation
- Skip failing tests temporarily
- Check test setup and teardown
- Verify mock configurations
- Review test data and fixtures

**For language-specific debugging:**
- #[[file:languages/typescript-testing-standards.md]] - TypeScript debugging with `.only()`, `.skip()`

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
- #[[file:languages/typescript-testing-standards.md]] - TypeScript testing patterns
- #[[file:security-policies.md]] - Security testing considerations
