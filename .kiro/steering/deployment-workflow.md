---
inclusion: always
description: Project workflow standards including GitHub issue management, branch naming, commit conventions, PR review, and deployment procedures
---

# Common Project Standards (General)

General project standards applicable to various projects.

**Note**: Language settings are configured in `language.md`

---

## Default Workflow for All Changes

**See #[[file:tech.md]] for development phase definitions**

Workflow depends on development phase:
- **Early**: Commit only (no push/PR/issue)
- **Mid**: Full issue/PR flow (see below)

**Transition**: After MVP complete, ask user: "MVP is complete. Switch to issue/PR workflow?"

### Mid Phase Workflow

1. Create GitHub issue first
2. Create branch from issue (format: `feat/issue-{number}-{description}`)
3. Make changes and run tests (`make test`)
4. Commit with issue reference (format: `feat: Description (Refs #{number})`)
5. Push and create PR (link issue with `Closes #{number}`)
6. Review and verify CI/CD checks pass
7. Merge when approved

**Do NOT ask for confirmation** - execute the appropriate flow based on current phase.

## Development Flow

All development work must start with a GitHub Issue.

**IMPORTANT - Initial Project Setup** (before 1st commit):

Run `make setup` to automatically configure your project:

```bash
make setup
```

This command will:
1. Install Git hooks (pre-commit, pre-push)
2. Install project dependencies
3. Verify your environment

**Manual Setup** (if `make setup` is not available):

1. Create `.tool-versions`:
```bash
mise use terraform@latest nodejs@lts python@latest
mise install
```

**IMPORTANT**: Verify versions after installation:
```bash
mise current
# Expected (as of 2026-03): terraform 1.14+, nodejs 24+, python 3.14+
```

2. Setup Git hooks:
```bash
# Install gitleaks (macOS)
brew install gitleaks

# Run setup script
bash .kiro/scripts/setup-git-hooks.sh
```

3. Create Makefile with required commands:
```makefile
.PHONY: help setup install test test-unit test-security clean setup-git-hooks pre-commit

help:
	@echo "Available commands:"
	@echo "  make setup          - Initial project setup (Git hooks + dependencies)"
	@echo "  make install        - Install dependencies"
	@echo "  make test           - Run all tests"
	@echo "  make test-unit      - Run unit tests"
	@echo "  make test-security  - Run security checks"
	@echo "  make pre-commit     - Run pre-commit checks"
	@echo "  make clean          - Clean build artifacts"

setup: setup-git-hooks install
	@echo "✅ Project setup complete!"

setup-git-hooks:
	@bash .kiro/scripts/setup-git-hooks.sh

install:
	# Add your install commands here

test: test-unit test-security

test-unit:
	# Add your test commands here

test-security:
	# Add security check commands here

pre-commit:
	@echo "🚀 Running pre-commit checks..."
	@bash .kiro/scripts/pre-commit-gitleaks.sh || exit 1
	@bash .kiro/scripts/pre-commit-filesize.sh || exit 1
	@bash .kiro/scripts/pre-commit-lint.sh || exit 1
	@echo "✅ All pre-commit checks passed!"

clean:
	# Add cleanup commands here
```

**After initial setup, follow the workflow below:**

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

**IMPORTANT - Never Skip Git Hooks:**
- NEVER use `--no-verify` flag with `git commit` or `git push`
- Git hooks (pre-commit, pre-push) are critical for code quality and security
- Skipping hooks bypasses essential checks (tests, secret scanning, linting)
- If hooks fail, fix the underlying issue instead of bypassing them

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
- Using `--no-verify` flag with git commands

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
make setup             # Initial project setup (Git hooks + dependencies)
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
