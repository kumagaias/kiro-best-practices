---
inclusion: always
---

# Common Technical Practices (General)

General best practices applicable to various programming languages and projects.

**Language-specific guides**: Use `#tech-typescript`, `#tech-python`, `#tech-go` in chat to include language-specific practices.

---

## Essential Commands

```bash
make help              # Show all commands
make install           # Install dependencies
make test              # Run all tests (unit + security)
make test-security     # Security checks only
make clean             # Clean build artifacts
```

**Note**: Always run `make test` before pushing

---

## Best Practices

### Code Quality
- Write clear, self-documenting code
- Keep functions small and focused (< 50 lines)
- Max file size: 500 lines
- Handle errors appropriately
- Follow language-specific conventions

### Testing
- Coverage target: 60% or higher
- Test edge cases
- Keep tests independent
- See #[[file:testing-standards.md]] for details

### Security
- Never hardcode sensitive information
- Use environment variables
- Sanitize all inputs
- See #[[file:security-policies.md]] for details

### Performance
- Optimize critical paths
- Use caching strategies
- Monitor resource usage

## Prohibited Practices

- ❌ Hardcoding sensitive data
- ❌ Large files (> 500 lines)
- ❌ Omitting error handling
- ❌ Direct commits to main branch
- ❌ Oversized PRs (> 500 lines)
- ❌ N+1 query problems

## Deployment

**For detailed procedures, see**: This file covers deployment in the Deployment Standards section above.

```bash
# Always test before push
make test
git push origin feat/issue-123-feature
```

---

**For language-specific practices:**
- #[[file:languages/typescript-code-conventions.md]] - TypeScript coding standards
- #[[file:languages/typescript-security-policies.md]] - TypeScript security
- #[[file:languages/typescript-testing-standards.md]] - TypeScript testing
- #[[file:languages/python.md]] - Python (coming soon)
- #[[file:languages/go.md]] - Go (coming soon)

**For specialized topics:**
- #[[file:security-policies.md]] - Security guidelines
- #[[file:deployment-workflow.md]] - Project standards and deployment
- #[[file:testing-standards.md]] - Testing approach and patterns
