#!/bin/bash

# Kiro Best Practices Installer
# Creates symlinks from ~/.kiro/ to repository files
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash

set -e

REPO_URL="https://github.com/kumagaias/kiro-best-practices"
BRANCH="${KIRO_BRANCH:-main}"
KIRO_HOME="$HOME/.kiro"
REPO_DIR="$KIRO_HOME/kiro-best-practices"

# Check if environment variables are set (non-interactive mode)
if [ -n "$KIRO_CHAT_LANG" ]; then
  INTERACTIVE=false
elif [ -t 0 ]; then
  INTERACTIVE=true
else
  INTERACTIVE=false
fi

echo "🚀 Kiro Best Practices Installer"
echo "================================="
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
  if [ -n "$1" ]; then
    CHAT_LANG="$1"
  else
    CHAT_LANG="${KIRO_CHAT_LANG:-English}"
  fi
fi

echo "✓ Agent chat language: $CHAT_LANG"
echo "✓ Project language: English (fixed)"
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
  
  if [ ! -d ".git" ]; then
    echo "❌ $REPO_DIR exists but is not a git repository"
    echo "   Please remove it manually: rm -rf $REPO_DIR"
    exit 1
  fi
  
  # Check for local changes
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "⚠️  Local changes detected in $REPO_DIR"
    echo "   These changes will be lost if you continue."
    echo ""
    if [ "$INTERACTIVE" = true ]; then
      read -p "Continue and discard local changes? (y/N): " -n 1 -r
      echo ""
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Update cancelled. Please commit or stash your changes first."
        exit 1
      fi
    else
      echo "⚠️  Non-interactive mode: Discarding local changes..."
    fi
  fi
  
  git fetch origin
  # If KIRO_BRANCH is explicitly set, switch to it; otherwise stay on current branch
  if [ -n "$KIRO_BRANCH" ]; then
    git reset --hard "origin/$BRANCH"
  else
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git reset --hard "origin/$CURRENT_BRANCH"
  fi
  echo "✅ Repository updated to latest version"
else
  echo "📦 Cloning repository..."
  git clone -b "$BRANCH" "$REPO_URL" "$REPO_DIR"
  echo "✅ Repository cloned"
fi

echo ""
echo "🔗 Creating symlinks to ~/.kiro/..."

# Create directory structure
echo "  📁 Creating directory structure..."
mkdir -p "$KIRO_HOME/hooks"
mkdir -p "$KIRO_HOME/settings"
mkdir -p "$KIRO_HOME/steering"
mkdir -p "$KIRO_HOME/scripts"
mkdir -p "$KIRO_HOME/agents"

# Create steering subdirectories
if [ -d "$REPO_DIR/.kiro/steering" ]; then
  find "$REPO_DIR/.kiro/steering" -type d | while read -r dir; do
    rel_dir="${dir#$REPO_DIR/.kiro/}"
    mkdir -p "$KIRO_HOME/$rel_dir"
  done
fi

# Helper function to create symlink
create_symlink() {
  local source="$1"
  local target="$2"
  
  # Remove existing file/symlink
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -f "$target"
  fi
  
  # Create symlink
  ln -s "$source" "$target"
  echo "  ✓ Linked $(basename "$target")"
}

# Symlink hooks (JSON files)
echo "  🔗 Linking hooks..."
while IFS= read -r -d '' file; do
  rel_path="${file#$REPO_DIR/.kiro/}"
  create_symlink "$file" "$KIRO_HOME/$rel_path"
done < <(find "$REPO_DIR/.kiro/hooks" -maxdepth 1 -name "*.json" -print0 2>/dev/null || true)

# Symlink settings (all JSON files)
echo "  🔗 Linking settings..."
while IFS= read -r -d '' file; do
  rel_path="${file#$REPO_DIR/.kiro/}"
  create_symlink "$file" "$KIRO_HOME/$rel_path"
done < <(find "$REPO_DIR/.kiro/settings" -maxdepth 1 -name "*.json" -print0 2>/dev/null || true)

# Symlink steering (MD files, excluding language template)
echo "  🔗 Linking steering files..."
while IFS= read -r -d '' file; do
  rel_path="${file#$REPO_DIR/.kiro/}"
  basename=$(basename "$file")
  
  if [ "$basename" = "kiro-language.md.example" ]; then
    continue
  fi
  
  create_symlink "$file" "$KIRO_HOME/$rel_path"
done < <(find "$REPO_DIR/.kiro/steering" -name "*.md" -print0 2>/dev/null || true)

# Create language.md from template
echo "  🌐 Creating language.md with chat: $CHAT_LANG..."
cp "$REPO_DIR/.kiro/steering/kiro-language.md.example" "$KIRO_HOME/steering/language.md"

if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/CHAT_LANGUAGE_PLACEHOLDER/$CHAT_LANG/g" "$KIRO_HOME/steering/language.md"
else
  sed -i "s/CHAT_LANGUAGE_PLACEHOLDER/$CHAT_LANG/g" "$KIRO_HOME/steering/language.md"
fi

# Symlink scripts
echo "  🔗 Linking scripts..."
while IFS= read -r -d '' file; do
  rel_path="${file#$REPO_DIR/.kiro/}"
  create_symlink "$file" "$KIRO_HOME/$rel_path"
done < <(find "$REPO_DIR/.kiro/scripts" -maxdepth 1 -name "*.sh" -print0 2>/dev/null || true)

# Symlink sync script from hooks/common/scripts
if [ -f "$REPO_DIR/.kiro/hooks/common/scripts/sync-spec-translations.sh" ]; then
  create_symlink "$REPO_DIR/.kiro/hooks/common/scripts/sync-spec-translations.sh" "$KIRO_HOME/scripts/sync-spec-translations.sh"
fi

# Symlink agents (JSON files)
echo "  🔗 Linking agents..."
while IFS= read -r -d '' file; do
  rel_path="${file#$REPO_DIR/.kiro/}"
  create_symlink "$file" "$KIRO_HOME/$rel_path"
done < <(find "$REPO_DIR/.kiro/agents" -maxdepth 1 -name "*.json" -print0 2>/dev/null || true)

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Installed to ~/.kiro/ (via symlinks):"
echo "  ✓ hooks/          - Agent hooks (symlinked)"
echo "  ✓ settings/       - MCP configuration (symlinked)"
echo "  ✓ steering/       - Development guidelines (symlinked)"
echo "  ✓ scripts/        - Utility scripts (symlinked)"
echo "  ✓ agents/         - Agent configurations (symlinked)"
echo ""
echo "🌐 Agent chat language: $CHAT_LANG"
echo ""
echo "💡 All files are symlinked - git pull auto-reflects updates"
echo ""
echo "📚 Update: cd ~/.kiro/kiro-best-practices && git pull"
echo "🔄 Reinstall: curl ... | bash (to update language settings)"
echo ""
