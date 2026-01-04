# Kiro Best Practices

Shared configuration and best practices for Kiro AI development environment.

## What's Included

- **Agent Hooks** - JSON-based hooks for Kiro agent automation
- **MCP Settings** - Model Context Protocol configuration templates
- **Steering Files** - Common development guidelines and best practices
- **Scripts** - Security checks and utility scripts
- **Project Templates** - Makefile, .tool-versions, GitHub templates

## Requirements

- Git
- Bash shell

## Installation

Install shared configuration to `~/.kiro/`:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash
```

**Language Configuration:**
- `KIRO_CHAT_LANG`: Agent chat language (default: English)
- `KIRO_DOCUMENT_LANG`: Documentation language (default: English, currently English only)

To use Japanese for agent chat:

```bash
KIRO_CHAT_LANG=Japanese curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash
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
