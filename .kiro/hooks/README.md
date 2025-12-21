# Agent Hooks

Agent automation hooks for consistent development practices.

## Structure

```
.kiro/hooks/
├── common/
│   ├── scripts/
│   │   ├── security-check.sh       # Security scanning script
│   │   └── setup-git-hooks.sh      # One-time Git hooks setup
│   ├── pre-commit-security.json    # Manual security check
│   ├── run-tests.json              # Run unit tests
│   └── run-all-tests.json          # Run all tests
└── README.md                        # This file
```

**Note:** Git hooks are in `.kiro/husky/` (symlinked to `.husky/`)

## Setup

### Automatic Setup

The installer script automatically creates a symbolic link:
- `.husky` → `.kiro/husky`

No manual setup required.

## Available Hooks

### Testing
- **run-tests.json** - Run unit tests manually
- **run-all-tests.json** - Run all tests (unit + security)

### Security
- **pre-commit-security.json** - Check for sensitive information

## Usage

### Via Command Palette
1. Open Command Palette (`Cmd/Ctrl + Shift + P`)
2. Search "Agent Hooks"
3. Select hook to execute

### Via Chat
Ask the agent to run a specific hook:
```
Run the "Run Unit Tests" hook
```

## Git Hooks

### pre-commit
- Runs security check with gitleaks
- Aborts commit if sensitive information detected

### pre-push
- Runs security check
- Aborts push if issues found

## Creating New Hooks

Create a JSON file in `.kiro/hooks/common/`:

```json
{
  "name": "Hook Name",
  "description": "What this hook does",
  "trigger": {
    "type": "manual"
  },
  "action": {
    "type": "shell",
    "command": "your-command"
  }
}
```

### Trigger Types
- **manual** - Execute via Command Palette or chat
- **onExecutionComplete** - Auto-execute when agent completes
- **onSessionCreate** - Auto-execute on session start

## Troubleshooting

### Git hooks not running

```bash
# Verify hooks exist
ls -la .husky

# Verify hook permissions
chmod +x .husky/pre-commit
chmod +x .husky/pre-push

# Verify husky is initialized
ls -la .husky/_/husky.sh
```

### Gitleaks not found

```bash
# Install gitleaks
brew install gitleaks

# Verify
gitleaks version
```
