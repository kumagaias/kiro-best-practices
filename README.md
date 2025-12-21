# Kiro Configuration Template

Shared Kiro configuration for consistent development practices across projects.

## Quick Start

```bash
# Download and run installer
curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/install.sh -o /tmp/kiro-install.sh
bash /tmp/kiro-install.sh
```

## Installation

### 1. Install required tools

```bash
# GitHub CLI (for GitHub MCP)
brew install gh
gh auth login

# Gitleaks (for security checks)
brew install gitleaks
```

### 2. Run installer

```bash
# Download installer
curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/install.sh -o /tmp/kiro-install.sh

# Run interactive installation
bash /tmp/kiro-install.sh
```

The installer will ask you to:
- Choose language (English or Japanese)
- Optionally enable additional MCP servers (AWS, Terraform, Playwright)

### 3. Customize (optional)

Edit these files for project-specific settings:
- `.kiro/steering/project.md` - Project standards
- `.kiro/steering/tech.md` - Technical details
- `.kiro/steering/structure.md` - Project structure
- `.kiro/settings/mcp.local.json` - Additional MCP servers
- `Makefile` - Add your project-specific commands

## What's Included

- **Hooks** - Agent hooks for testing and security (in `.kiro/hooks/`)
- **Steering** - Development guidelines and best practices
- **Settings** - MCP server configurations (fetch, github)
- **Git Hooks** - Pre-commit security checks (symlinked to `.husky/`)
- **GitHub** - Workflows, PR/Issue templates, Copilot review automation (symlinked to `.github/`)
- **Makefile** - Common development tasks (test, install, clean)
- **Language** - Configurable language settings (English/Japanese)

## MCP Servers

**Default (always enabled):**
- `fetch` - HTTP requests
- `github` - GitHub operations

**Optional (enable in `mcp.local.json`):**
- `aws-docs` - AWS documentation
- `terraform` - Terraform operations
- `playwright` - Browser automation

See `.kiro/settings/README.md` for details.

## Usage

### Agent Hooks

Open Command Palette (`Cmd/Ctrl + Shift + P`) → "Agent Hooks"

- **Run Unit Tests** - Execute tests
- **Security Check** - Check for secrets

### Verify Setup

```bash
git add .
git commit -m "test: Verify setup" --allow-empty
# Should run security checks automatically
```

## Updating

```bash
# Backup customizations
cp -r .kiro .kiro.backup

# Download and run installer
curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/install.sh -o /tmp/kiro-install.sh
bash /tmp/kiro-install.sh

# Restore customizations (merge manually)
```

## Structure

```
.kiro/
├── hooks/          # Agent hooks
├── settings/       # MCP configuration
├── steering/       # Development guidelines
├── husky/          # Git hooks (symlinked to .husky)
└── github/         # GitHub config (symlinked to .github)
```

**Note:** `.husky` and `.github` are symbolic links to `.kiro/husky` and `.kiro/github` respectively.

## Contributing

1. Fork this repository
2. Create feature branch (`git checkout -b feat/amazing-feature`)
3. Commit changes (`git commit -m 'feat: Add amazing feature'`)
4. Push to branch (`git push origin feat/amazing-feature`)
5. Open Pull Request

## License

MIT
