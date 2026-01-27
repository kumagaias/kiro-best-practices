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
- `KIRO_PROJECT_LANG`: Project-specific language for documentation, Issues, and PRs (default: English)

To use Japanese for agent chat:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | KIRO_CHAT_LANG=Japanese bash
```

Or use positional arguments:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash -s Japanese
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash -s Japanese Japanese
```

**Note**: Global configuration (~/.kiro/) is always in English. Project language setting affects project-specific files only.

## Update

To update to the latest version, run the install script again:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash
```

This will:
1. Update the repository in `~/.kiro/kiro-best-practices`
2. Copy updated files to `~/.kiro/` (you'll be prompted for conflicts)

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
