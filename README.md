# Kiro Best Practices

Issue/PR-based development workflow for Kiro AI + GitHub.

Shared configuration and best practices for Kiro development environment.

## Requirements

- [GitHub CLI](https://cli.github.com/) - `brew install gh`

## Installation

Install shared configuration to `~/.kiro/`:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash
```

**Language Configuration:**
- `KIRO_CHAT_LANG`: Agent chat language (default: English)

To use Japanese for agent chat:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | KIRO_CHAT_LANG=Japanese bash
```

Or use positional argument:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash -s Japanese
```

**Note**: Project language is fixed to English for all projects (README, Issues, PRs, commits).

## Update

To update to the latest version, run the install script again:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash
```

This will:
1. Update the repository in `~/.kiro/kiro-best-practices`
2. Copy updated files to `~/.kiro/` (you'll be prompted for conflicts)

**⚠️ Important**: If you've customized files in `~/.kiro/`, they will be overwritten. Customizations should be made in project-specific `.kiro/` directories instead.

## Customization

### Global vs Project-Specific Configuration

- **Global (`~/.kiro/`)**: Shared across all projects, managed by this repository
- **Project-Specific (`.kiro/` in each project)**: Overrides global settings

**Precedence**: Project-specific settings override global settings.

**Best Practices:**
- Keep common standards in global configuration
- Customize project-specific settings in `.kiro/` within each project
- Don't modify `~/.kiro/` directly - it will be overwritten on update

### What to Customize Where

**Global (`~/.kiro/`)**:
- General coding standards (tech.md, security-policies.md)
- Common hooks (pre-commit checks, test runners)
- MCP server configurations (mcp.json)
- Language preferences (language.md)

**Project-Specific (`.kiro/`)**:
- Project-specific steering files
- Custom hooks for project workflows
- Project-specific MCP configurations
- Templates and documentation

## Uninstall

Remove shared configuration:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/uninstall.sh | bash
```

Note: This will NOT remove project-specific `.kiro/` directories.

## Structure

```
~/.kiro/
├── kiro-best-practices/     # This repository (git clone)
│   └── .kiro/
│       ├── hooks/
│       ├── settings/
│       ├── steering/
│       ├── scripts/
│       ├── templates/       # Templates (not copied)
│       └── docs/            # Documentation (not copied)
├── hooks/          # Copied from kiro-best-practices/.kiro/hooks/*.json
├── settings/       # Copied from kiro-best-practices/.kiro/settings/*.json
├── steering/       # Copied from kiro-best-practices/.kiro/steering/*.md
└── scripts/        # Copied from kiro-best-practices/.kiro/scripts/*.sh
```

**Note**: Files are copied (not symlinked) to ensure compatibility across all projects. Templates and docs remain in the repository.

## License

MIT
