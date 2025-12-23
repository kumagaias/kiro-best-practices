#!/bin/bash

# Kiro Configuration Uninstaller (Submodule Version)
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/uninstall-submodule.sh | bash

set -e

echo "🗑️  Uninstalling Kiro configuration (submodule version)..."
echo ""

# Check if submodule exists
if [ ! -d ".kiro-template" ]; then
  echo "❌ .kiro-template submodule not found"
  echo "   Maybe you used the standalone version?"
  echo "   Try: curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/uninstall.sh | bash"
  exit 1
fi

# Confirm
echo "⚠️  This will remove:"
echo "  - .kiro-template/ (submodule)"
echo "  - .kiro/"
echo "  - .husky/"
echo "  - .github/"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 0
fi

# Remove submodule
echo "📦 Removing submodule..."
git submodule deinit -f .kiro-template 2>/dev/null || true
git rm -f .kiro-template 2>/dev/null || true
rm -rf .git/modules/.kiro-template 2>/dev/null || true
echo "✅ Submodule removed"

# Remove directories
echo "📁 Removing directories..."
rm -rf .kiro
rm -rf .husky
rm -rf .github
echo "✅ Directories removed"

# Ask about Makefile and .tool-versions
echo ""
read -p "Remove Makefile? (y/N): " -n 1 -r REMOVE_MAKEFILE
echo ""
if [[ $REMOVE_MAKEFILE =~ ^[Yy]$ ]]; then
  rm -f Makefile
  echo "✅ Makefile removed"
fi

echo ""
read -p "Remove .tool-versions? (y/N): " -n 1 -r REMOVE_TOOL_VERSIONS
echo ""
if [[ $REMOVE_TOOL_VERSIONS =~ ^[Yy]$ ]]; then
  rm -f .tool-versions
  echo "✅ .tool-versions removed"
fi

echo ""
echo "✨ Uninstallation complete!"
echo ""
echo "📋 Next steps:"
echo "  git add ."
echo "  git commit -m 'chore: Remove giro configuration'"
echo ""
