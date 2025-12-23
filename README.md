# Kiro Configuration Template

Shared Kiro configuration for consistent development practices across projects.

## What's Included

- **Hooks** - Agent hooks for testing and security
- **Steering** - Development guidelines
- **Settings** - MCP configurations (fetch, github)
- **Git Hooks** - Pre-commit security checks
- **GitHub** - Workflows, PR/Issue templates
- **Makefile** - Common tasks

## Requirements

```bash
brew install gitleaks gh
gh auth login
```

## Installation

### Standalone (For Users)

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/install.sh | bash
```

### Submodule (For Contributors)

```bash
git init  # if needed
curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/install-submodule.sh | bash
# Auto-commit option available
```

## Updating

### Standalone

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/install.sh | bash
# Choose "1) Update only"
```

### Submodule

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/update-submodule.sh | bash
# Auto-commit option available
```

## Verify Setup

```bash
git commit -m "test: Verify setup" --allow-empty
# Should run security checks
```

## Contributing

```bash
cd .kiro-template
git checkout -b feat/improve-something
# Make changes
git add .
git commit -m "feat: Improve something"
git push origin feat/improve-something
gh pr create
```

## Uninstalling

### Standalone

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/uninstall.sh | bash
```

### Submodule

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/uninstall-submodule.sh | bash
```

## License

MIT
