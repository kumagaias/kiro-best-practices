---
inclusion: always
description: Project workflow standards including GitHub issue management, branch naming, commit conventions, PR review, and deployment procedures
---

# Common Project Standards (General)

General project standards applicable to various projects.

**Note**: Language settings are configured in `language.md`

---

## Default Workflow for All Changes

**IMPORTANT**: Unless explicitly told otherwise, ALWAYS follow this workflow:

1. Create GitHub issue first
2. Create branch from issue (format: `feat/issue-{number}-{description}`)
3. Make changes and run tests (`make test`)
4. Commit with issue reference (format: `feat: Description (Refs #{number})`)
5. Push and create PR (link issue with `Closes #{number}`)
6. Review and verify CI/CD checks pass
7. Merge when approved

**Do NOT ask for confirmation** - execute this flow automatically when user requests changes.

## Development Flow

All development work must start with a GitHub Issue.

**IMPORTANT**: For new projects, create `.tool-versions` first:

```bash
# Initialize tool versions (run once per project)
mise use terraform@latest nodejs@lts python@latest
# Or: asdf local terraform latest && asdf local nodejs lts && asdf local python latest

# Install tools
mise install  # or: asdf install
```

```bash
# 1. Create GitHub Issue
gh issue create --title "Add user authentication" --body "Description..."

# 2. Create branch with issue number
git checkout -b feat/issue-123-add-user-authentication

# 3. Implement & test
make test

# 4. Commit with issue reference
git commit -m "feat: Add user authentication (Refs #123)"

# 5. Push and create PR
git push origin feat/issue-123-add-user-authentication
gh pr create --title "feat: Add user authentication" --body "Closes #123"
```

**Key Points:**
- Always create Issue first
- Include issue number in branch name
- Reference issue in commits (`Refs #123`)
- Link issue in PR (`Closes #123`)

### Commit Message Format

```
<type>: <subject> (Refs #<issue-number>)
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Branch Naming

```
<type>/issue-<number>-<description>
```

Examples: `feat/issue-123-add-auth`, `fix/issue-456-memory-leak`

## PR Review Process

Before merging, verify:
- PR diff reviewed (no unintended changes)
- Commit messages follow conventions
- All CI/CD checks pass (tests, linting, security)
- Code review approved (if required)

**Optional**: Request GitHub Copilot review via MCP for automated feedback

## Bug Fix Workflow

```bash
# 1. Create GitHub Issue
gh issue create --title "Fix login error" --body "Description..."

# 2. Create fix branch
git checkout -b fix/issue-{number}-{description}

# 3. Fix & test
make test

# 4. Commit with issue reference
git commit -m "fix: [description] (Fixes #{number})"

# 5. Create PR
gh pr create --title "fix: [description]" --body "Fixes #{number}"
```

**❌ Prohibited:**
- Skipping Issue creation
- Fixing directly on main branch
- Working without issue number

## Testing Requirements

```bash
make test              # All tests
make test-unit         # Unit tests only
make test-security     # Security checks
```

**Coverage Target**: 60% or higher

**For detailed testing standards, see**: #[[file:testing-standards.md]]

## Documentation Requirements

### Required Files
- `README.md` - Project overview (max 200 lines)
- `structure.md` - Project structure
- `tech.md` - Technical details

### File Size Guidelines
- **README.md**: Max 200 lines
- **Source files**: Max 500 lines per file

### Specs File Naming

Use `issue-{number}-{description}.md` format to prevent conflicts:
- `.kiro/specs/bugfix/issue-123-fix-login-error.md`
- `.kiro/specs/feature/issue-456-add-user-profile.md`

## Deployment

### Pre-deployment Checklist
- [ ] All tests pass
- [ ] Security checks pass
- [ ] Documentation updated
- [ ] Code reviewed

### Deployment Flow
1. Run all tests
2. Deploy to staging (if available)
3. Verify in staging
4. Deploy to production
5. Monitor and verify

## Postmortem (Optional)

Create postmortems for security incidents, production failures, or critical bugs.

**Structure:**
1. Overview (1-2 sentences)
2. Timeline
3. Root Cause
4. Impact
5. Resolution
6. Prevention

## Makefile Standards

### Required Commands

```bash
make help              # Display available commands
make install           # Install dependencies
make test              # Run all tests (unit + security)
make test-unit         # Run unit tests only
make test-security     # Run security checks
make clean             # Clean build artifacts
```

### Optional Commands

Add as needed: `test-e2e`, `test-lint`, `dev`, `build`, `deploy`

---

**Related guides:**
- #[[file:security-policies.md]] - Security guidelines
- #[[file:testing-standards.md]] - Testing approach and patterns
- #[[file:skills/typescript-code-conventions.md]] - TypeScript coding standards
- #[[file:skills/terraform-code-conventions.md]] - Terraform coding standards
- #[[file:skills/react-native-conventions.md]] - React Native best practices
