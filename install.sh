#!/bin/bash

# Kiro Best Practices Installer
# Installs shared configuration to ~/.kiro/
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/install.sh | bash

set -e

REPO_URL="https://github.com/kumagaias/kiro-best-practices"
BRANCH="${KIRO_BRANCH:-main}"
KIRO_HOME="$HOME/.kiro"
REPO_DIR="$KIRO_HOME/kiro-best-practices"

echo "🚀 Kiro Best Practices Installer"
echo "================================"
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
            settings/mcp.json settings/mcp.local.json.example \
            steering/project.md steering/tech.md \
            scripts/security-check.sh scripts/setup-git-hooks.sh; do
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
  echo "Options:"
  echo "  1) Overwrite all (replace with symlinks)"
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
      echo "Invalid choice. Installation cancelled."
      exit 1
      ;;
  esac
  echo ""
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

# Create symlinks for individual files
echo "  🔗 Creating symlinks..."

# Hooks
should_skip "hooks/pre-commit-security.json" || ln -sf "$REPO_DIR/.kiro/hooks/pre-commit-security.json" "$KIRO_HOME/hooks/pre-commit-security.json"
should_skip "hooks/run-all-tests.json" || ln -sf "$REPO_DIR/.kiro/hooks/run-all-tests.json" "$KIRO_HOME/hooks/run-all-tests.json"
should_skip "hooks/run-tests.json" || ln -sf "$REPO_DIR/.kiro/hooks/run-tests.json" "$KIRO_HOME/hooks/run-tests.json"

# Settings
should_skip "settings/mcp.json" || ln -sf "$REPO_DIR/.kiro/settings/mcp.json" "$KIRO_HOME/settings/mcp.json"
should_skip "settings/mcp.local.json.example" || ln -sf "$REPO_DIR/.kiro/settings/mcp.local.json.example" "$KIRO_HOME/settings/mcp.local.json.example"

# Steering
should_skip "steering/project.md" || ln -sf "$REPO_DIR/.kiro/steering/project.md" "$KIRO_HOME/steering/project.md"
should_skip "steering/tech.md" || ln -sf "$REPO_DIR/.kiro/steering/tech.md" "$KIRO_HOME/steering/tech.md"

# Scripts
should_skip "scripts/security-check.sh" || ln -sf "$REPO_DIR/.kiro/scripts/security-check.sh" "$KIRO_HOME/scripts/security-check.sh"
should_skip "scripts/setup-git-hooks.sh" || ln -sf "$REPO_DIR/.kiro/scripts/setup-git-hooks.sh" "$KIRO_HOME/scripts/setup-git-hooks.sh"

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
echo "📖 Next Steps:"
echo ""
echo "1. Setup Git hooks in your project:"
echo "   cd /path/to/your/project"
echo "   ~/.kiro/scripts/setup-git-hooks.sh"
echo ""
echo "2. Copy project templates (optional):"
echo "   cp ~/.kiro/kiro-best-practices/.kiro/templates/Makefile.example ./Makefile"
echo "   cp ~/.kiro/kiro-best-practices/.kiro/templates/.tool-versions.example ./.tool-versions"
echo ""
echo "3. MCP configuration:"
echo "   Common MCP settings are in ~/.kiro/settings/mcp.json"
echo "   For project-specific settings, create .kiro/settings/mcp.json"
echo ""
echo "4. Add project-specific steering files:"
echo "   mkdir -p .kiro/steering"
echo "   # Create .kiro/steering/structure.md"
echo "   # Create .kiro/steering/project.md (project-specific)"
echo ""
echo "💡 Tip: Kiro reads from both ~/.kiro/ and .kiro/"
echo "   - ~/.kiro/settings/mcp.json (common)"
echo "   - .kiro/settings/mcp.json (project-specific, optional)"
echo "   - ~/.kiro/steering/ (common guidelines)"
echo "   - .kiro/steering/ (project-specific guidelines)"
echo ""
echo "📚 Documentation: ~/.kiro/kiro-best-practices/.kiro/docs/"
echo "📦 Templates: ~/.kiro/kiro-best-practices/.kiro/templates/"
echo ""
