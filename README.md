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
- `KIRO_DOCUMENT_LANG`: Documentation language (default: English)

To use Japanese for agent chat:

```bash
KIRO_CHAT_LANG=Japanese curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash
```

**Note**: If the language setting doesn't work, download and run the script directly:
```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh -o /tmp/install-kiro.sh
KIRO_CHAT_LANG=Japanese bash /tmp/install-kiro.sh
```

## Update

```bash
cd ~/.kiro/kiro-best-practices && git pull
```

To change language: Re-run install with `KIRO_CHAT_LANG=Japanese`

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
│       ├── templates/       # Templates (not symlinked)
│       └── docs/            # Documentation (not symlinked)
├── hooks/          -> kiro-best-practices/.kiro/hooks/*.json
├── settings/       -> kiro-best-practices/.kiro/settings/*.json
├── steering/       -> kiro-best-practices/.kiro/steering/*.md
└── scripts/        -> kiro-best-practices/.kiro/scripts/*.sh
```

**Note**: Only files that Kiro reads are symlinked. Templates and docs are accessed directly from the repository.

## License

MIT
