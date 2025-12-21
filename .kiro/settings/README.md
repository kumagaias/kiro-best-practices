# Kiro Settings

Configuration files for Kiro IDE.

## MCP Configuration

### File Structure

- `mcp.json` - Common MCP servers (shared across projects)
- `mcp.local.json` - Project-specific MCP servers (gitignored)
- `mcp.local.json.example` - Template for project-specific settings

### Usage

#### 1. Use common settings only

If you only need the common MCP servers (fetch, github), no additional setup is required.

#### 2. Add project-specific settings

```bash
# Copy the example file
cp .kiro/settings/mcp.local.json.example .kiro/settings/mcp.local.json

# Edit to enable/disable servers for your project
# Example: Enable aws-docs and terraform for AWS projects
```

**Note:** Kiro merges configurations with the following precedence:
- User config (global) < Workspace config < Local config (highest priority)

#### 3. Customize for your project

Edit `mcp.local.json`:

```json
{
  "mcpServers": {
    "aws-docs": {
      "disabled": false  // Enable for AWS projects
    },
    "terraform": {
      "disabled": false  // Enable for IaC projects
    },
    "playwright": {
      "disabled": false  // Enable for E2E testing projects
    }
  }
}
```

### Common MCP Servers

Always available:

- **fetch** - HTTP requests and web scraping
- **github** - GitHub operations (PRs, issues, commits)

### Optional MCP Servers

Enable in `mcp.local.json` as needed:

- **aws-docs** - AWS documentation search
- **terraform** - Terraform operations
- **chrome-devtools** - Chrome DevTools integration
- **playwright** - Browser automation

### Gitignore

Add to your `.gitignore`:

```
# Project-specific MCP settings
.kiro/settings/mcp.local.json
```

This allows each developer to have their own MCP configuration without affecting others.

## Reconnecting MCP Servers

After changing configuration:

1. Open Kiro feature panel
2. Find "MCP Server" view
3. Click reconnect icon

Or restart Kiro IDE.

## Troubleshooting

### Server not found

Check if the server is installed:

```bash
# For uvx servers
uv --version

# For npx servers
npm --version
```

### Authentication issues (GitHub)

```bash
# Re-authenticate
gh auth login

# Verify token
gh auth token
```

### Server disabled

Check `disabled` flag in configuration:

```json
{
  "mcpServers": {
    "your-server": {
      "disabled": false  // Should be false to enable
    }
  }
}
```
