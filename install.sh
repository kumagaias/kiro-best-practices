#!/bin/bash

# Kiro Best Practices Installer
# Installs shared configuration to ~/.kiro/
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash
#   OVERWRITE=1 curl -fsSL ... | bash  # Force overwrite
#   SKIP=1 curl -fsSL ... | bash       # Skip existing files

set -e

REPO_URL="https://github.com/kumagaias/kiro-best-practices"
BRANCH="${KIRO_BRANCH:-main}"
KIRO_HOME="$HOME/.kiro"
REPO_DIR="$KIRO_HOME/kiro-best-practices"

# Check if running in non-interactive mode (piped from curl)
if [ -t 0 ]; then
  INTERACTIVE=true
else
  INTERACTIVE=false
fi

echo "🚀 Kiro Best Practices Installer"
echo "================================"
echo ""

# Language selection
if [ "$INTERACTIVE" = true ]; then
  echo "🌐 Select your preferred language for Agent chat:"
  echo "  1) English"
  echo "  2) Japanese (日本語)"
  echo ""
  read -p "Choose [1-2] (default: 1): " -n 1 -r
  echo ""
  
  case $REPLY in
    1|"")
      CHAT_LANG="English"
      ;;
    2)
      CHAT_LANG="Japanese"
      ;;
    *)
      echo "❌ Invalid choice. Using default (English)."
      CHAT_LANG="English"
      ;;
  esac
else
  # Non-interactive mode: check if variables were passed via bash -s
  # Usage: curl ... | KIRO_CHAT_LANG=Japanese bash
  # Or: curl ... | bash -s Japanese
  if [ -n "$1" ]; then
    CHAT_LANG="$1"
  else
    CHAT_LANG="${KIRO_CHAT_LANG:-English}"
  fi
fi

# Document language (currently only English available)
if [ -n "$2" ]; then
  PROJECT_LANG="$2"
else
  PROJECT_LANG="${KIRO_PROJECT_LANG:-English}"
fi

echo "✓ Agent chat language: $CHAT_LANG"
echo "✓ Project language: $PROJECT_LANG"
echo ""

# Check if ~/.kiro exists
if [ ! -d "$KIRO_HOME" ]; then
  echo "📁 Creating ~/.kiro directory..."
  mkdir -p "$KIRO_HOME"
fi

# Clone or update repository
if [ -d "$REPO_DIR" ]; then
  echo "📦 Repository already exists. Updating..."
  cd "$REPO_DIR"
  
  # Check if it's a git repository
  if [ ! -d ".git" ]; then
    echo "❌ $REPO_DIR exists but is not a git repository"
    echo "   Please remove it manually: rm -rf $REPO_DIR"
    exit 1
  fi
  
  # Update repository
  git fetch origin
  git reset --hard "origin/$BRANCH"
  echo "✅ Repository updated to latest version"
else
  echo "📦 Cloning repository..."
  git clone -b "$BRANCH" "$REPO_URL" "$REPO_DIR"
  echo "✅ Repository cloned"
fi

echo ""
echo "📋 Installing shared files to ~/.kiro/..."

# Check for existing files
CONFLICTS=()
for file in hooks/pre-commit-security.json hooks/run-all-tests.json hooks/run-tests.json \
            hooks/commit-push-pr.json hooks/documentation-update-reminder.json hooks/setup-on-session-start.json \
            settings/mcp.json \
            steering/project.md steering/tech.md steering/deployment-workflow.md steering/language.md \
            steering/security-policies.md \
            scripts/security-check.sh; do
  [ -e "$KIRO_HOME/$file" ] && CONFLICTS+=("$file")
done

# Handle conflicts
SKIP_FILES=()
if [ ${#CONFLICTS[@]} -gt 0 ]; then
  echo ""
  echo "⚠️  Existing files found in ~/.kiro/:"
  for item in "${CONFLICTS[@]}"; do
    if [ -L "$KIRO_HOME/$item" ]; then
      echo "  - $item (symlink)"
    else
      echo "  - $item"
    fi
  done
  echo ""
  # Non-interactive mode: use environment variables or default to overwrite
  if [ "$INTERACTIVE" = false ]; then
    if [ "$SKIP" = "1" ]; then
      echo "⏭️  Skipping all existing files (SKIP=1)..."
      SKIP_FILES=("${CONFLICTS[@]}")
    else
      echo "🔄 Overwriting all existing files (default in non-interactive mode)..."
      for item in "${CONFLICTS[@]}"; do
        rm -f "$KIRO_HOME/$item" 2>/dev/null || true
      done
    fi
  else
    # Interactive mode: ask user
    echo "Options:"
    echo "  1) Overwrite all (replace with new copies)"
    echo "  2) Skip all (keep existing files)"
    echo "  3) Ask for each file"
    echo ""
    read -p "Choose [1-3]: " -n 1 -r
    echo ""
    
    case $REPLY in
      1)
        echo "🔄 Overwriting all existing files..."
        for item in "${CONFLICTS[@]}"; do
          rm -f "$KIRO_HOME/$item" 2>/dev/null || true
        done
        ;;
      2)
        echo "⏭️  Skipping all existing files..."
        SKIP_FILES=("${CONFLICTS[@]}")
        ;;
      3)
        echo ""
        for item in "${CONFLICTS[@]}"; do
          echo "File: $item"
          read -p "  Overwrite? (y/N): " -n 1 -r
          echo ""
          if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            SKIP_FILES+=("$item")
            echo "  ⏭️  Skipped"
          else
            rm -f "$KIRO_HOME/$item" 2>/dev/null || true
            echo "  ✓ Will overwrite"
          fi
          echo ""
        done
        ;;
      *)
        echo "❌ Invalid choice. Installation cancelled."
        exit 1
        ;;
    esac
  fi
fi

# Create directory structure
echo "  📁 Creating directory structure..."
mkdir -p "$KIRO_HOME/hooks"
mkdir -p "$KIRO_HOME/settings"
mkdir -p "$KIRO_HOME/steering"
mkdir -p "$KIRO_HOME/scripts"

# Helper function to check if file should be skipped
should_skip() {
  local file="$1"
  for skip in "${SKIP_FILES[@]}"; do
    [ "$skip" = "$file" ] && return 0
  done
  return 1
}

# Copy files
echo "  📄 Copying files..."

# Hooks
should_skip "hooks/pre-commit-security.json" || cp "$REPO_DIR/.kiro/hooks/pre-commit-security.json" "$KIRO_HOME/hooks/pre-commit-security.json"
should_skip "hooks/run-all-tests.json" || cp "$REPO_DIR/.kiro/hooks/run-all-tests.json" "$KIRO_HOME/hooks/run-all-tests.json"
should_skip "hooks/run-tests.json" || cp "$REPO_DIR/.kiro/hooks/run-tests.json" "$KIRO_HOME/hooks/run-tests.json"
should_skip "hooks/commit-push-pr.json" || cp "$REPO_DIR/.kiro/hooks/commit-push-pr.json" "$KIRO_HOME/hooks/commit-push-pr.json"
should_skip "hooks/documentation-update-reminder.json" || cp "$REPO_DIR/.kiro/hooks/documentation-update-reminder.json" "$KIRO_HOME/hooks/documentation-update-reminder.json"
should_skip "hooks/setup-on-session-start.json" || cp "$REPO_DIR/.kiro/hooks/setup-on-session-start.json" "$KIRO_HOME/hooks/setup-on-session-start.json"

# Settings
should_skip "settings/mcp.json" || cp "$REPO_DIR/.kiro/settings/mcp.json" "$KIRO_HOME/settings/mcp.json"

# Steering
should_skip "steering/project.md" || cp "$REPO_DIR/.kiro/steering/project.md" "$KIRO_HOME/steering/project.md"
should_skip "steering/tech.md" || cp "$REPO_DIR/.kiro/steering/tech.md" "$KIRO_HOME/steering/tech.md"
should_skip "steering/deployment-workflow.md" || cp "$REPO_DIR/.kiro/steering/deployment-workflow.md" "$KIRO_HOME/steering/deployment-workflow.md"
should_skip "steering/security-policies.md" || cp "$REPO_DIR/.kiro/steering/security-policies.md" "$KIRO_HOME/steering/security-policies.md"

# Language configuration - copy template and customize
if ! should_skip "steering/language.md"; then
  echo "  🌐 Creating language.md with chat: $CHAT_LANG, project: $PROJECT_LANG..."
  
  # Copy template
  cp "$REPO_DIR/.kiro/steering/kiro-language.md.example" "$KIRO_HOME/steering/language.md"
  
  # Replace placeholders using sed (more reliable than perl for simple substitution)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/CHAT_LANGUAGE_PLACEHOLDER/$CHAT_LANG/g" "$KIRO_HOME/steering/language.md"
    sed -i '' "s/PROJECT_LANGUAGE_PLACEHOLDER/$PROJECT_LANG/g" "$KIRO_HOME/steering/language.md"
  else
    # Linux
    sed -i "s/CHAT_LANGUAGE_PLACEHOLDER/$CHAT_LANG/g" "$KIRO_HOME/steering/language.md"
    sed -i "s/PROJECT_LANGUAGE_PLACEHOLDER/$PROJECT_LANG/g" "$KIRO_HOME/steering/language.md"
  fi
fi

# Scripts
should_skip "scripts/security-check.sh" || cp "$REPO_DIR/.kiro/scripts/security-check.sh" "$KIRO_HOME/scripts/security-check.sh"

# Set execute permissions on scripts
chmod +x "$KIRO_HOME/scripts"/*.sh 2>/dev/null || true

# Show skipped files
if [ ${#SKIP_FILES[@]} -gt 0 ]; then
  echo ""
  echo "⏭️  Skipped files (existing files kept):"
  for item in "${SKIP_FILES[@]}"; do
    echo "  - $item"
  done
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Installed to ~/.kiro/:"
echo "  ✓ hooks/          - Agent hooks (JSON)"
echo "  ✓ settings/       - MCP configuration templates"
echo "  ✓ steering/       - Common development guidelines"
echo "  ✓ scripts/        - Git hooks and utility scripts"
echo ""
echo "🌐 Agent chat language: $CHAT_LANG
📚 Project language: $PROJECT_LANG"
echo ""
echo "💡 Kiro will automatically use these shared files"
echo ""
echo "📚 Update: cd ~/.kiro/kiro-best-practices && git pull"
echo "🔄 Change language: curl ... | KIRO_CHAT_LANG=Japanese bash"
echo ""
