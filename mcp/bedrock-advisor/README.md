# MCP Bedrock Advisor

AI advisor MCP server using AWS Bedrock for helping when stuck on problems.

## Features

- Ask AI advisor questions when stuck
- Powered by Claude Haiku 4.5 via AWS Bedrock (low cost: ~$0.25/$1.25 per 1M tokens)
- Simple MCP tool integration

## Prerequisites

- Node.js 18+
- AWS account with credentials configured (`~/.aws/credentials`)
- AWS Bedrock model access (Global Claude Haiku 4.5 inference profile)

## Installation

### Option 1: Via install script (Recommended)

Enable during installation:

```bash
curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | ENABLE_BEDROCK=true bash
```

### Option 2: Manual installation

1. Build the MCP server:

```bash
cd mcp/bedrock-advisor
npm install
npm run build
```

2. Enable in MCP configuration (`.kiro/settings/mcp.json`):

Change `"disabled": true` to `"disabled": false` in the `bedrock-advisor` section.

**Note**: By default, bedrock-advisor is disabled to avoid requiring AWS credentials for all users.

## Usage

The MCP server provides two tools:

### 1. ask_advisor

Ask AI advisor questions when stuck:

```typescript
// Kiro will automatically use this tool when needed
{
  question: "How do I fix this error?",
  context: "Error message and code context (optional)"
}
```

### 2. record_attempt

Record error fix attempts (auto-escalates after 2+ attempts):

```typescript
// Call BEFORE every error fix attempt
{
  error_key: "TypeError: cannot read properties of undefined",
  what_i_tried: "Added null check before accessing property",
  code_context: "const value = obj.property; // line 42 (optional)"
}
```

The tool automatically escalates to AI advisor if the same error occurs 2+ times.

## Development

```bash
npm run dev    # Watch mode
npm run build  # Build
npm start      # Run
```

## License

MIT
