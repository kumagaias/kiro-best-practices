---
inclusion: always
---

# Common Technical Practices (General)

General best practices applicable to various programming languages and projects.

**Language-specific guides**: Use `#tech-typescript`, `#tech-python`, `#tech-go` in chat to include language-specific practices.

---

## Project Initialization Guide

### Quick Start (Existing Project)

When cloning an existing project:

```bash
# 1. Clone repository
git clone <repository-url>
cd <project-name>

# 2. Install dependencies (language-specific)
# See language-specific tech guide

# 3. Setup Git hooks (one-time)
~/.kiro/scripts/setup-git-hooks.sh

# 4. Install gitleaks (security checks)
brew install gitleaks  # macOS
# Or see: https://github.com/gitleaks/gitleaks#installing

# 5. Setup GitHub CLI (for GitHub MCP)
brew install gh  # macOS
gh auth login
# Follow prompts to authenticate

# 6. Configure environment variables (if needed)
# Copy .env.example files and edit with your values

# 7. Run tests to verify setup
make test
```

### New Project Setup (From Scratch)

#### Step 1: Install from kiro-best-practices

```bash
# Install shared configuration
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash

# Follow prompts to select language/framework
```

#### Step 2: Copy Essential Files

```bash
# Copy Makefile template
cp ~/.kiro/kiro-best-practices/.kiro/templates/Makefile.example ./Makefile

# Copy tool versions
cp ~/.kiro/kiro-best-practices/.kiro/templates/.tool-versions.example ./.tool-versions

# Copy GitHub templates (optional)
cp -r ~/.kiro/kiro-best-practices/.kiro/templates/github/ ./.github/
```

#### Step 3: Setup Git Hooks

```bash
# Run setup script
~/.kiro/scripts/setup-git-hooks.sh
```

#### Step 4: Install Security Tools

```bash
# Install gitleaks
# macOS
brew install gitleaks

# Linux (Debian/Ubuntu)
wget https://github.com/gitleaks/gitleaks/releases/download/v8.18.1/gitleaks_8.18.1_linux_x64.tar.gz
tar -xzf gitleaks_8.18.1_linux_x64.tar.gz
sudo mv gitleaks /usr/local/bin/

# Windows (via Scoop)
scoop install gitleaks

# Verify installation
gitleaks version
```

#### Step 5: Verify Setup

```bash
# Run tests
make test

# Check security
make test-security

# Verify Git hooks work
git add .
git commit -m "test: Verify hooks" --allow-empty
# Should run security checks automatically
```

### Essential Files Checklist

When setting up a new project, ensure these files exist:

- [ ] `.gitignore` - Ignore patterns
- [ ] `.gitleaks.toml` - Gitleaks configuration
- [ ] `Makefile` - Common tasks
- [ ] `.tool-versions` - Tool version requirements
- [ ] `README.md` - Project overview

## Makefile Commands

The Makefile provides convenient commands for common development tasks.

### Essential Commands

```bash
# Show all available commands
make help

# Install all dependencies
make install

# Run all tests (comprehensive)
make test

# Run security checks
make test-security

# Clean build artifacts
make clean

# Check required tools
make check-tools
```

### Important Notes

- **`make test` is comprehensive**: Runs ALL tests including unit, integration, security checks
- **Gitleaks is required**: Security checks will fail if Gitleaks is not installed
- **Run before push**: Always run `make test` before pushing to ensure all checks pass

### Tool Installation

#### Required Tools

```bash
# Gitleaks (security scanning)
brew install gitleaks  # macOS
# See: https://github.com/gitleaks/gitleaks#installing

# GitHub CLI (for GitHub MCP)
brew install gh  # macOS
gh auth login  # Authenticate with GitHub

# Make (usually pre-installed)
make --version
```

#### Optional Tools

```bash
# Terraform (if using IaC)
brew install terraform  # macOS

# AWS CLI (if using AWS)
brew install awscli  # macOS

# Docker (if using containers)
brew install docker  # macOS
```

### Troubleshooting

#### Git Hooks Not Running

```bash
# Verify husky installation
ls -la .husky

# Recreate if needed
~/.kiro/scripts/setup-git-hooks.sh

# Verify hook permissions
chmod +x .husky/pre-commit
chmod +x .husky/pre-push
```

#### Gitleaks Not Found

```bash
# Check installation
which gitleaks

# Install if missing
brew install gitleaks  # macOS

# Verify
gitleaks version
```

#### Security Check Fails

```bash
# Run manually to see details
~/.kiro/scripts/security-check.sh

# Check specific files
gitleaks detect --source . --verbose
```

---

## General Best Practices

### Security

**For detailed security guidelines, see**: `#security-policies`

Basic principles:
- Never hardcode sensitive information
- Use environment variables for secrets
- Sanitize input data
- Apply principle of least privilege

### Performance

- Optimize critical paths
- Use caching strategies
- Implement connection pooling
- Monitor resource usage

### Code Quality

- Write clear, self-documenting code
- Follow language-specific conventions
- Keep functions small and focused
- Avoid deep nesting
- Handle errors appropriately
- Write meaningful comments for complex logic

### Testing

- **Coverage Target**: 60% or higher
- Write tests before fixing bugs
- Test edge cases
- Use descriptive test names
- Keep tests independent

### File Organization

- **Max file size**: 500 lines per file
- Group related functionality
- Use clear directory structure
- Separate concerns

## Prohibited Practices

### Code Quality
- ❌ Omitting error handling
- ❌ Hardcoding sensitive data
- ❌ Large files (> 500 lines per file)
- ❌ Unclear variable names

### Git Workflow
- ❌ Direct commits to main branch
- ❌ Oversized PRs (> 500 lines)
- ❌ Commits without issue reference

### Performance
- ❌ Unlimited data fetching
- ❌ N+1 query problems
- ❌ Memory leaks

## Deployment Best Practices

**For detailed deployment procedures, see**: `#deployment-workflow`

Basic principles:
1. Pull before push
2. Always run tests before deployment
3. Deploy to staging first
4. Monitor post-deployment
5. Have rollback plan ready

```bash
# Correct push procedure
git add .
git commit -m "feat: Add feature (Refs #123)"
git pull origin feat/issue-123-feature
git push origin feat/issue-123-feature
```

---

**For language-specific practices, refer to:**
- `.kiro/steering/tech-typescript.md` - TypeScript/React/Node.js (use `#tech-typescript`)
- `.kiro/steering/tech-python.md` - Python (use `#tech-python`)
- `.kiro/steering/tech-go.md` - Go (use `#tech-go`)

**For specialized topics, use:**
- `#security-policies` - Security guidelines
- `#deployment-workflow` - Deployment procedures
