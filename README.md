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

**Configuration Options:**
- `KIRO_CHAT_LANG`: Agent chat language (default: English)

To use Japanese for agent chat:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | KIRO_CHAT_LANG=Japanese bash
```

**Note**: Project language is fixed to English for all projects (README, Issues, PRs, commits).

## Update

To update to the latest version:

```bash
cd ~/.kiro/kiro-best-practices && git pull
```

All files are symlinked, so updates automatically reflect in `~/.kiro/`. Only `language.md` needs reinstallation if you want to change the chat language.

## Bedrock Advisor

Bedrock Advisor is disabled by default. To enable it (requires AWS account), edit:

```bash
# Edit the repository file directly
vim ~/.kiro/kiro-best-practices/.kiro/settings/mcp.json
# Set "disabled": false for the bedrock-advisor entry
```

## Customization

### Global vs Project-Specific Configuration

- **Global (`~/.kiro/`)**: Shared across all projects, managed by this repository
- **Project-Specific (`.kiro/` in each project)**: Overrides global settings

**Precedence**: Project-specific settings override global settings.

**Best Practices:**
- Keep common standards in global configuration
- Customize project-specific settings in `.kiro/` within each project
- Don't modify `~/.kiro/` directly - symlinks point to the repository

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

Or run locally:

```bash
cd ~/.kiro/kiro-best-practices && ./uninstall.sh
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
│       ├── agents/
│       ├── templates/       # Templates (not symlinked)
│       └── docs/            # Documentation (not symlinked)
├── hooks/          # Symlinked
├── settings/       # Symlinked (including mcp.json)
├── steering/       # language.md copied, others symlinked
├── scripts/        # Symlinked
└── agents/         # Symlinked
```

**Note**: All files are symlinked for automatic updates via `git pull`. Only `language.md` is copied for customization.

## License

MIT
