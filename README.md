# Kiro Best Practices

Shared configuration and best practices for Kiro AI development environment.

## What's Included

- **Agent Hooks** - JSON-based hooks for Kiro agent automation
- **MCP Settings** - Model Context Protocol configuration templates
- **Steering Files** - Common development guidelines (project.md, tech.md)
- **Git Hooks** - Security checks and pre-commit/pre-push scripts
- **Project Templates** - Husky, GitHub, Makefile, .tool-versions

## Requirements

- Git
- Bash shell
- Node.js (for projects using Git hooks)

## Installation

Install shared configuration to `~/.kiro/`:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash
```

This will:
1. Clone this repository to `~/.kiro/kiro-best-practices/`
2. Create symlinks from `~/.kiro/` to repository files (hooks, settings, steering, scripts, templates)

**Note**: Files are symlinked, so updates to the repository automatically reflect in `~/.kiro/`

## Usage

### Setup Git Hooks in Your Project

```bash
cd /path/to/your/project
~/.kiro/scripts/setup-git-hooks.sh
```

This will:
- Install husky (if not already installed)
- Copy hook templates from `~/.kiro/templates/husky/`
- Configure hooks to call `~/.kiro/scripts/security-check.sh`

### Use MCP Configuration

Common MCP settings are installed to `~/.kiro/settings/mcp.json` and automatically used by Kiro.

For project-specific MCP settings:
```bash
# Create project-specific MCP configuration
mkdir -p .kiro/settings
vim .kiro/settings/mcp.json
```

Kiro will merge both configurations (project settings override common settings).

### Use Project Templates

```bash
# Copy Makefile template
cp ~/.kiro/kiro-best-practices/.kiro/templates/Makefile.example ./Makefile

# Copy tool versions
cp ~/.kiro/kiro-best-practices/.kiro/templates/.tool-versions.example ./.tool-versions

# Copy GitHub templates
cp -r ~/.kiro/kiro-best-practices/.kiro/templates/github/ ./.github/
```

### Steering Files

Kiro will automatically read steering files from:
- `~/.kiro/steering/` - Common guidelines (shared across all projects)
- `.kiro/steering/` - Project-specific guidelines

Create project-specific steering files:
```bash
mkdir -p .kiro/steering
# Create .kiro/steering/structure.md
# Create .kiro/steering/project.md (project-specific overrides)
```

## Update

Update shared configuration:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/update.sh | bash
```

Or manually:
```bash
cd ~/.kiro/kiro-best-practices
git pull
```

**Note**: Since files are symlinked, `git pull` automatically updates all shared files.

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
