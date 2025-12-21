#!/bin/bash

# Kiro Configuration Installer
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/install.sh | bash

set -e

REPO_URL="https://github.com/kumagaias/giro"
BRANCH="${KIRO_BRANCH:-main}"
TEMP_DIR=$(mktemp -d)
TARGET_DIR=".kiro"

echo "🚀 Installing Kiro configuration..."
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
  echo "❌ Git is not installed. Please install git first."
  exit 1
fi

# Clone repository
echo "📦 Downloading configuration from $REPO_URL..."
if ! git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
  echo "❌ Failed to download. Please check:"
  echo "   - Repository URL: $REPO_URL"
  echo "   - Branch: $BRANCH"
  echo "   - Internet connection"
  exit 1
fi

# Copy .kiro directory
if [ -d "$TARGET_DIR" ]; then
  echo ""
  echo "⚠️  .kiro directory already exists in current directory."
  read -p "Overwrite? (y/N): " -n 1 -r < /dev/tty
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    rm -rf "$TEMP_DIR"
    exit 0
  fi
  rm -rf "$TARGET_DIR"
fi

echo "📁 Copying .kiro directory..."
cp -r "$TEMP_DIR/.kiro" "$TARGET_DIR"
echo "✅ .kiro directory copied"

# Language selection
echo ""
echo "🌐 Language Configuration"
echo ""

# Chat language
echo "1️⃣  Agent Chat Language"
echo "  What language should the agent use in chat?"
echo "    1) English"
echo "    2) 日本語 (Japanese)"
read -p "  Enter your choice (1 or 2) [default: 2]: " -n 1 -r CHAT_CHOICE < /dev/tty
echo ""
case "$CHAT_CHOICE" in
  1) CHAT_LANG="English" ;;
  *) CHAT_LANG="Japanese" ;;
esac
echo "  ✅ Chat language: $CHAT_LANG"
echo ""

# Documentation language
echo "2️⃣  Documentation Language"
echo "  What language should be used for internal docs (steering, specs)?"
echo "    1) English"
echo "    2) 日本語 (Japanese)"
read -p "  Enter your choice (1 or 2) [default: 1]: " -n 1 -r DOC_CHOICE < /dev/tty
echo ""
case "$DOC_CHOICE" in
  2) DOC_LANG="Japanese" ;;
  *) DOC_LANG="English" ;;
esac
echo "  ✅ Documentation language: $DOC_LANG"
echo ""

# Code comment language
echo "3️⃣  Code Comment Language"
echo "  What language should be used for code comments?"
echo "    1) English"
echo "    2) 日本語 (Japanese)"
read -p "  Enter your choice (1 or 2) [default: 1]: " -n 1 -r COMMENT_CHOICE < /dev/tty
echo ""
case "$COMMENT_CHOICE" in
  2) COMMENT_LANG="Japanese" ;;
  *) COMMENT_LANG="English" ;;
esac
echo "  ✅ Code comment language: $COMMENT_LANG"
echo ""

# Generate language.md
echo "📝 Generating language configuration..."

cat > "$TARGET_DIR/steering/language.md" << EOF
---
inclusion: always
---

# Language Settings

## Communication Standards

- **Agent chat**: $CHAT_LANG
- **Documentation**: $DOC_LANG
- **Code comments**: $COMMENT_LANG
- **README files**: English (max 200 lines)
- **GitHub PRs/Issues**: English
- **Commit messages**: English

## Instructions for Agent

### Chat Language: $CHAT_LANG

EOF

if [ "$CHAT_LANG" = "Japanese" ]; then
  cat >> "$TARGET_DIR/steering/language.md" << 'EOF'
- すべてのチャットでの会話は日本語で行ってください
- エラーメッセージの説明も日本語で提供してください
- ユーザーとのコミュニケーションは日本語で行ってください

EOF
else
  cat >> "$TARGET_DIR/steering/language.md" << 'EOF'
- All chat conversations should be conducted in English
- Provide error message explanations in English
- Communicate with users in English

EOF
fi

cat >> "$TARGET_DIR/steering/language.md" << EOF
### Documentation Language: $DOC_LANG

EOF

if [ "$DOC_LANG" = "Japanese" ]; then
  cat >> "$TARGET_DIR/steering/language.md" << 'EOF'
- プロジェクト内部のドキュメント（steering, specs など）は日本語で記述してください
- ただし、README.md は英語で記述してください（国際標準）
- 技術仕様書やデザインドキュメントは日本語で記述してください

EOF
else
  cat >> "$TARGET_DIR/steering/language.md" << 'EOF'
- All project documentation should be written in English
- This includes steering files, specs, and README files
- Technical specifications and design documents should be in English

EOF
fi

cat >> "$TARGET_DIR/steering/language.md" << EOF
### Code Comment Language: $COMMENT_LANG

EOF

if [ "$COMMENT_LANG" = "Japanese" ]; then
  cat >> "$TARGET_DIR/steering/language.md" << 'EOF'
- コード内のコメントは日本語で記述してください
- 関数やクラスの説明コメントも日本語で記述してください
- インラインコメントも日本語で記述してください

EOF
else
  cat >> "$TARGET_DIR/steering/language.md" << 'EOF'
- All code comments should be written in English
- This includes function, class, and inline comments
- JSDoc, TSDoc, and similar documentation comments should be in English

EOF
fi

cat >> "$TARGET_DIR/steering/language.md" << 'EOF'
## Fixed Rules (Unchangeable)

Always use English for:
- GitHub PR/Issue titles and descriptions
- Commit messages
- README.md (project root)
- Public API documentation

## File Naming Conventions

- All file names should use English
- Examples: `project.md`, `tech.md`, `structure.md`
EOF

echo "✅ Language configuration complete"

# Hosting platform selection
echo ""
echo "☁️  Hosting Platform"
echo "  Select your hosting platform:"
echo "    1) AWS (Lambda, API Gateway, DynamoDB, S3, CloudFront)"
echo "    2) Platform (Vercel, Render, Railway, Forge, etc.)"
read -p "  Enter your choice (1 or 2) [default: 2]: " -n 1 -r HOSTING_CHOICE < /dev/tty
echo ""

case "$HOSTING_CHOICE" in
  1)
    echo "  📝 Setting up AWS structure..."
    cp "$TARGET_DIR/steering-examples/common/structure-aws.md" "$TARGET_DIR/steering/structure.md"
    echo "  ✅ AWS structure template copied"
    ;;
  *)
    echo "  📝 Setting up default structure..."
    cp "$TARGET_DIR/steering-examples/common/structure-default.md" "$TARGET_DIR/steering/structure.md"
    echo "  ✅ Default structure template copied"
    ;;
esac
echo ""

# Create placeholder project-specific files
echo "📝 Creating project-specific steering files..."

if [ ! -f "$TARGET_DIR/steering/project.md" ]; then
  cat > "$TARGET_DIR/steering/project.md" << 'EOF'
# Project Standards

Project-specific standards and conventions.

See `.kiro/steering/common/project.md` for common standards.

---

## Project-Specific Rules

Add your project-specific rules here.

## Team Conventions

Add your team conventions here.

## Workflow

Add your workflow here.
EOF
  echo "  ✅ project.md created"
fi

if [ ! -f "$TARGET_DIR/steering/tech.md" ]; then
  cat > "$TARGET_DIR/steering/tech.md" << 'EOF'
# Technical Details

Project-specific technical details and architecture.

See `.kiro/steering/common/tech.md` for common practices.

---

## Architecture

Describe your project architecture here.

## Technology Stack

List your technology stack here.

## Development Setup

Add development setup instructions here.
EOF
  echo "  ✅ tech.md created"
fi

echo ""

# Copy Makefile
echo ""
echo "📝 Setting up Makefile..."
if [ -f "Makefile" ]; then
  echo "⚠️  Makefile already exists. Skipping."
  echo "   See Makefile.example for reference"
else
  cp "$TEMP_DIR/Makefile.example" "Makefile"
  echo "✅ Makefile created from template"
  echo "   Customize it for your project"
fi

# Copy .tool-versions
echo ""
echo "🔧 Setting up .tool-versions..."
if [ -f ".tool-versions" ]; then
  echo "⚠️  .tool-versions already exists. Skipping."
else
  cp "$TEMP_DIR/.tool-versions.example" ".tool-versions"
  echo "✅ .tool-versions created from template"
  echo "   Edit to specify your tool versions"
fi

# Cleanup
rm -rf "$TEMP_DIR"

# Setup Git hooks
echo ""
echo "🔗 Setting up Git hooks..."
if [ -d "$TARGET_DIR/hooks/common/.husky" ]; then
  if [ -L ".husky" ] || [ -d ".husky" ]; then
    echo "⚠️  .husky already exists. Skipping symlink creation."
    echo "   To use Kiro hooks, remove .husky and run:"
    echo "   ln -s .kiro/hooks/common/.husky .husky"
  else
    ln -s ".kiro/hooks/common/.husky" ".husky"
    echo "✅ Git hooks linked to .husky"
    echo "   Source: .kiro/hooks/common/.husky"
    echo "   Link: .husky"
  fi
else
  echo "ℹ️  No Git hooks found in template"
fi

# Optional: MCP server configuration
echo ""
echo "🔧 MCP Server Configuration"
read -p "Do you want to enable optional MCP servers? (y/N): " -n 1 -r MCP_CHOICE < /dev/tty
echo ""

if [[ $MCP_CHOICE =~ ^[Yy]$ ]]; then
  echo ""
  echo "Available optional MCP servers:"
  echo "  1) aws-docs - AWS documentation search"
  echo "  2) terraform - Terraform operations"
  echo "  3) playwright - Browser automation"
  echo "  4) All of the above"
  echo "  5) None (skip)"
  echo ""
  read -p "Enter your choice (1-5) [default: 5]: " -n 1 -r SERVER_CHOICE < /dev/tty
  echo ""
  
  case "$SERVER_CHOICE" in
    1)
      echo "Enabling aws-docs..."
      cat > "$TARGET_DIR/settings/mcp.local.json" << 'EOF'
{
  "mcpServers": {
    "aws-docs": {
      "command": "uvx",
      "args": ["awslabs.aws-documentation-mcp-server@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
EOF
      echo "✅ aws-docs enabled"
      ;;
    2)
      echo "Enabling terraform..."
      cat > "$TARGET_DIR/settings/mcp.local.json" << 'EOF'
{
  "mcpServers": {
    "terraform": {
      "command": "uvx",
      "args": ["awslabs.terraform-mcp-server@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
EOF
      echo "✅ terraform enabled"
      ;;
    3)
      echo "Enabling playwright..."
      cat > "$TARGET_DIR/settings/mcp.local.json" << 'EOF'
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@executeautomation/playwright-mcp-server"],
      "disabled": false,
      "autoApprove": []
    }
  }
}
EOF
      echo "✅ playwright enabled"
      ;;
    4)
      echo "Enabling all optional servers..."
      cp "$TARGET_DIR/settings/mcp.local.json.example" "$TARGET_DIR/settings/mcp.local.json"
      echo "✅ All optional servers enabled"
      ;;
    *)
      echo "ℹ️  Skipping optional MCP servers"
      ;;
  esac
else
  echo "ℹ️  Skipping MCP server configuration"
fi

# Copy Makefile
echo ""
echo "📝 Setting up Makefile..."
if [ -f "Makefile" ]; then
  echo "⚠️  Makefile already exists. Skipping."
  echo "   See Makefile.example for reference"
else
  cp "$TEMP_DIR/Makefile.example" "Makefile"
  echo "✅ Makefile created from template"
  echo "   Customize it for your project"
fi

# Copy .tool-versions
echo ""
echo "🔧 Setting up .tool-versions..."
if [ -f ".tool-versions" ]; then
  echo "⚠️  .tool-versions already exists. Skipping."
else
  cp "$TEMP_DIR/.tool-versions.example" ".tool-versions"
  echo "✅ .tool-versions created from template"
  echo "   Edit to specify your tool versions"
fi

# Cleanup
rm -rf "$TEMP_DIR"

# Setup Git hooks
echo ""
echo "🔗 Setting up Git hooks..."
if [ -L ".husky" ] || [ -d ".husky" ]; then
  echo "⚠️  .husky already exists. Skipping symlink creation."
  echo "   To recreate: rm -rf .husky && ln -s .kiro/husky .husky"
else
  ln -s ".kiro/husky" ".husky"
  echo "✅ Git hooks linked"
  echo "   .husky -> .kiro/husky"
fi

# Setup GitHub configuration
echo ""
echo "🔗 Setting up GitHub configuration..."
if [ -L ".github" ] || [ -d ".github" ]; then
  echo "⚠️  .github already exists. Skipping symlink creation."
  echo "   To recreate: rm -rf .github && ln -s .kiro/github .github"
else
  ln -s ".kiro/github" ".github"
  echo "✅ GitHub configuration linked"
  echo "   .github -> .kiro/github"
fi

echo ""
echo "✨ Installation complete!"
echo ""
echo "📋 Next steps:"
echo ""
echo "1. Install required tools:"
echo "   brew install gitleaks          # Security scanning"
echo "   brew install gh && gh auth login  # GitHub CLI"
echo ""
echo "2. Customize for your project:"
echo "   - Edit Makefile (add your build/test commands)"
echo "   - Edit .tool-versions (specify tool versions)"
echo "   - Edit .kiro/steering/project.md"
echo "   - Edit .kiro/steering/tech.md"
echo "   - Edit .kiro/steering/structure.md"
echo ""
echo "3. Verify setup:"
echo "   git add ."
echo "   git commit -m \"test: Verify hooks\" --allow-empty"
echo ""
echo "📚 Documentation: $REPO_URL"
echo ""
