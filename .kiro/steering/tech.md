---
inclusion: always
description: General technical best practices including code quality, testing, security, performance, and language-specific conventions
---

# Common Technical Practices (General)

General best practices applicable to various programming languages and projects.

**Language-specific guides**: Use `#tech-typescript`, `#tech-python`, `#tech-go` in chat to include language-specific practices.

**IMPORTANT - Development Principles**:
- Always ask users for clarification when requirements are unclear
- Measure, don't guess - verify assumptions with data and testing
- Research thoroughly - check documentation, search online, and investigate specifications before implementing
- Use MCP tools and web search to get current information and verify implementation details
- Avoid exaggerated expressions like "Perfect!" or "Amazing!" - keep communication professional and factual

**IMPORTANT - Requirements Compliance**:
- NEVER propose removing or bypassing mandatory technical requirements
- If implementation is difficult, report the blocker and ask for guidance
- Do NOT unilaterally change the approach to circumvent requirements

**IMPORTANT - Development Phases**:

| Phase | When | Focus | Testing | Workflow |
|-------|------|-------|---------|----------|
| **Early** | Project start, until MVP | Speed priority | Critical paths only | Commit only |
| **Mid** | After MVP + user confirmation | Quality priority | 60%+ coverage | Full issue/PR flow |

**IMPORTANT - File Size Limit**:
- Max file size: 500 lines per file
- If a file exceeds 500 lines, you MUST split it into smaller, focused modules
- This applies to all source files, not documentation

**IMPORTANT - Documentation Size Limit**:
- README.md and other documentation files: Max 200 lines
- Keep documentation concise and focused
- Split into multiple files if needed (e.g., README.md, ARCHITECTURE.md, API.md)

**IMPORTANT - Environment Naming**:
- Use standard environment names: `dev`, `stag`, `prod`
- Apply consistently across infrastructure, configs, and tags

**IMPORTANT - Hosting Environment Verification**:
- Before making any deployment or hosting-related changes, ALWAYS verify the current hosting environment first
- Check configuration files (amplify.yml, vercel.json, netlify.toml, etc.) to identify the actual hosting platform
- Review related files (package.json scripts, CI/CD configs) to understand the deployment setup
- Do NOT assume the hosting platform - verify it explicitly to avoid incorrect modifications

**IMPORTANT - Code Change Principles**:
- Before changing code, ALWAYS check logs to identify the root cause
- One change solves one problem - do NOT make multiple changes simultaneously
- Do NOT break working functionality
- Do NOT add "workaround code" or "fallback logic" without addressing the root cause
- Fix the root cause, not the symptoms
- When stuck on a problem, use the `bedrock-advisor` MCP tool to consult with AI for guidance

**IMPORTANT - Error Handling Rule**:
- Before attempting to fix an error, call `record_attempt` tool with error details
- If you encounter the same error message or attempt the same fix more than twice, STOP
- The `record_attempt` tool automatically escalates to AI advisor after 2+ attempts
- Do NOT continue trying to solve it yourself after auto-escalation
- Repeated failed attempts waste time - get expert help immediately
- Note: `bedrock-advisor` MCP server is optional and requires AWS account (disabled by default)

---

## Tool Version Management

**IMPORTANT**: Always create `.tool-versions` at project start to lock tool versions.

Use mise or asdf to manage tool versions consistently across projects.

### Initial Setup (per project)

```bash
# Create .tool-versions with latest LTS/stable versions
mise use terraform@latest nodejs@lts python@latest

# Or with asdf
asdf local terraform latest
asdf local nodejs lts
asdf local python latest

# Install tools
mise install  # or: asdf install
```

### Version Selection Guidelines

- **terraform**: Use `@latest` for latest stable version
- **nodejs**: Use `@lts` for Long Term Support version (recommended for production)
- **python**: Use `@latest` for latest stable version

**Note**: 
- Always use latest LTS or stable versions at project start
- Tool versions are captured at project start and committed to `.tool-versions`
- Use `@lts` for Node.js to ensure stability (not `@latest`)
- The `.tool-versions` file locks versions for consistent environments across team
- Each project should have its own `.tool-versions` file

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
- Max file size: 500 lines (split into smaller modules if exceeded)
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
- #[[file:skills/typescript-code-conventions.md]] - TypeScript coding standards
- #[[file:skills/typescript-security-policies.md]] - TypeScript security
- #[[file:skills/typescript-testing-standards.md]] - TypeScript testing
- #[[file:skills/terraform-code-conventions.md]] - Terraform/IaC standards
- #[[file:skills/react-native-conventions.md]] - React Native best practices
- #[[file:skills/python.md]] - Python (coming soon)
- #[[file:skills/go.md]] - Go (coming soon)

**For specialized topics:**
- #[[file:security-policies.md]] - Security guidelines
- #[[file:deployment-workflow.md]] - Project standards and deployment
- #[[file:testing-standards.md]] - Testing approach and patterns
