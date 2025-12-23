#!/bin/bash

# Kiro Configuration Installer (Submodule Version)
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/install-submodule.sh | bash

set -e

REPO_URL="https://github.com/kumagaias/giro"
BRANCH="${KIRO_BRANCH:-main}"
SUBMODULE_DIR=".kiro-template"
TARGET_DIR=".kiro"

echo "🚀 Installing Kiro configuration (submodule version)..."
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
  echo "❌ Git is not installed. Please install git first."
  exit 1
fi

# Check if we're in a git repository
if [ ! -d ".git" ]; then
  echo "❌ Not a git repository. Please run 'git init' first."
  exit 1
fi

# Check if submodule already exists
if [ -d "$SUBMODULE_DIR" ]; then
  echo ""
  echo "⚠️  .kiro-template submodule already exists."
  echo ""
  echo "Choose update mode:"
  echo "  1) Update submodule to latest"
  echo "  2) Reinstall (remove and re-add)"
  echo "  3) Cancel"
  read -p "Enter your choice (1-3) [default: 1]: " -n 1 -r UPDATE_MODE < /dev/tty
  echo ""
  
  case "$UPDATE_MODE" in
    2)
      echo "📦 Removing old submodule..."
      git submodule deinit -f "$SUBMODULE_DIR"
      git rm -f "$SUBMODULE_DIR"
      rm -rf ".git/modules/$SUBMODULE_DIR"
      echo "✅ Old submodule removed"
      ;;
    3)
      echo "Installation cancelled."
      exit 0
      ;;
    *)
      echo "📦 Updating submodule..."
      git submodule update --remote "$SUBMODULE_DIR"
      echo "✅ Submodule updated"
      echo ""
      echo "💡 Commit the update:"
      echo "   git add .kiro-template"
      echo "   git commit -m 'chore: Update giro template'"
      exit 0
      ;;
  esac
fi

# Add submodule
echo "📦 Adding giro as submodule..."
if ! git submodule add -b "$BRANCH" "$REPO_URL" "$SUBMODULE_DIR" 2>/dev/null; then
  echo "❌ Failed to add submodule. Please check:"
  echo "   - Repository URL: $REPO_URL"
  echo "   - Branch: $BRANCH"
  echo "   - Internet connection"
  exit 1
fi

echo "✅ Submodule added: $SUBMODULE_DIR"
echo ""

# Initialize submodule
git submodule update --init --recursive

# Create .kiro directory structure
echo "📁 Setting up .kiro directory..."
mkdir -p "$TARGET_DIR/steering"
mkdir -p "$TARGET_DIR/settings"

# Create symlinks for common files
echo "🔗 Creating symlinks for common files..."

# Remove existing symlinks/directories if they exist
[ -L "$TARGET_DIR/hooks" ] && rm "$TARGET_DIR/hooks"
[ -L "$TARGET_DIR/steering/common" ] && rm "$TARGET_DIR/steering/common"
[ -L "$TARGET_DIR/steering-examples" ] && rm "$TARGET_DIR/steering-examples"
[ -L "$TARGET_DIR/scripts" ] && rm "$TARGET_DIR/scripts"
[ -L "$TARGET_DIR/settings/mcp.json" ] && rm "$TARGET_DIR/settings/mcp.json"
[ -L "$TARGET_DIR/settings/mcp.local.json.example" ] && rm "$TARGET_DIR/settings/mcp.local.json.example"
[ -L ".husky" ] && rm ".husky"
[ -L ".github" ] && rm ".github"

# Create symlinks
ln -s "../$SUBMODULE_DIR/.kiro/hooks" "$TARGET_DIR/hooks"
ln -s "../../$SUBMODULE_DIR/.kiro/steering/common" "$TARGET_DIR/steering/common"
ln -s "../$SUBMODULE_DIR/.kiro/giro/steering-examples" "$TARGET_DIR/steering-examples"
ln -s "../$SUBMODULE_DIR/.kiro/giro" "$TARGET_DIR/scripts"
ln -s "../../$SUBMODULE_DIR/.kiro/settings/mcp.json" "$TARGET_DIR/settings/mcp.json"
ln -s "../../$SUBMODULE_DIR/.kiro/settings/mcp.local.json.example" "$TARGET_DIR/settings/mcp.local.json.example"
ln -s "$SUBMODULE_DIR/.kiro/giro/husky" ".husky"
ln -s "$SUBMODULE_DIR/.kiro/giro/github" ".github"

echo "✅ Symlinks created"
echo ""

# Language selection
echo "🌐 Language Configuration"
echo ""

# Chat language
echo "1️⃣  Agent Chat Language"
echo "  What language should the agent use in chat?"
echo "    1) English"
echo "    2) 日本語 (Japanese)"
read -p "  Enter your choice (1 or 2) [default: 1]: " -n 1 -r CHAT_CHOICE < /dev/tty
echo ""
case "$CHAT_CHOICE" in
  2) CHAT_LANG="Japanese" ;;
  *) CHAT_LANG="English" ;;
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
echo "    1) None (Generic structure)"
echo "    2) AWS (Lambda, API Gateway, DynamoDB, S3, CloudFront)"
read -p "  Enter your choice (1 or 2) [default: 1]: " -n 1 -r HOSTING_CHOICE < /dev/tty
echo ""

case "$HOSTING_CHOICE" in
  2)
    echo "  📝 Setting up AWS structure..."
    cp "$SUBMODULE_DIR/.kiro/giro/steering-examples/common/structure-aws.md" "$TARGET_DIR/steering/structure.md"
    echo "  ✅ AWS structure template copied"
    ;;
  *)
    echo "  📝 Setting up default structure..."
    cp "$SUBMODULE_DIR/.kiro/giro/steering-examples/common/structure-default.md" "$TARGET_DIR/steering/structure.md"
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
echo "📝 Setting up Makefile..."
if [ -f "Makefile" ]; then
  echo "⚠️  Makefile already exists. Skipping."
  echo "   See $SUBMODULE_DIR/.kiro/giro/Makefile.example for reference"
else
  cp "$SUBMODULE_DIR/.kiro/giro/Makefile.example" "Makefile"
  echo "✅ Makefile created from template"
  echo "   Customize it for your project"
fi

# Copy .tool-versions
echo ""
echo "🔧 Setting up .tool-versions..."
if [ -f ".tool-versions" ]; then
  echo "⚠️  .tool-versions already exists. Skipping."
else
  cp "$SUBMODULE_DIR/.kiro/giro/.tool-versions.example" ".tool-versions"
  echo "✅ .tool-versions created from template"
  echo "   Edit to specify your tool versions"
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
      cp "$SUBMODULE_DIR/.kiro/settings/mcp.local.json.example" "$TARGET_DIR/settings/mcp.local.json"
      echo "✅ All optional servers enabled"
      ;;
    *)
      echo "ℹ️  Skipping optional MCP servers"
      ;;
  esac
else
  echo "ℹ️  Skipping MCP server configuration"
fi

echo ""
echo "✨ Installation complete!"
echo ""

# Ask if user wants to commit
read -p "Commit changes now? (Y/n): " -n 1 -r AUTO_COMMIT < /dev/tty
echo ""

if [[ ! $AUTO_COMMIT =~ ^[Nn]$ ]]; then
  echo "📦 Committing changes..."
  git add .gitmodules .kiro-template .kiro .husky .github Makefile .tool-versions 2>/dev/null || true
  git commit -m "chore: Add giro configuration as submodule" 2>/dev/null || {
    echo "⚠️  Commit failed. You may need to commit manually."
  }
  echo "✅ Changes committed"
  echo ""
fi

echo "📋 Next steps:"
echo ""
echo "1. Install required tools:"
echo "   brew install gitleaks gh"
echo "   gh auth login"
echo ""
echo "2. Customize for your project:"
echo "   - Edit Makefile"
echo "   - Edit .kiro/steering/project.md"
echo "   - Edit .kiro/steering/tech.md"
echo ""
echo "3. Verify setup:"
echo "   git commit -m \"test: Verify hooks\" --allow-empty"
echo ""
echo "📚 To update later:"
echo "   git submodule update --remote .kiro-template"
echo ""
echo "📚 Documentation: $REPO_URL"
echo ""
