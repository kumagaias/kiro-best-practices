#!/bin/bash

# Kiro Configuration Updater (Submodule Version)
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/update-submodule.sh | bash

set -e

echo "🔄 Updating Kiro configuration (submodule version)..."
echo ""

# Check if submodule exists
if [ ! -d ".kiro-template" ]; then
  echo "❌ .kiro-template submodule not found"
  echo "   Maybe you used the standalone version?"
  echo "   Try: curl -fsSL https://raw.githubusercontent.com/kumagaias/giro/main/install.sh | bash"
  exit 1
fi

# Update submodule
echo "📦 Updating submodule to latest..."
git submodule update --remote .kiro-template

# Check if there are changes
if git diff --quiet .kiro-template; then
  echo "✅ Already up to date"
  exit 0
fi

echo "✅ Submodule updated"
echo ""

# Show changes
echo "📋 Changes:"
cd .kiro-template
git log --oneline HEAD@{1}..HEAD 2>/dev/null || echo "  (Unable to show changes)"
cd ..
echo ""

# Ask if user wants to commit
read -p "Commit changes now? (Y/n): " -n 1 -r AUTO_COMMIT < /dev/tty
echo ""

if [[ ! $AUTO_COMMIT =~ ^[Nn]$ ]]; then
  echo "📦 Committing changes..."
  git add .kiro-template
  git commit -m "chore: Update giro template" 2>/dev/null || {
    echo "⚠️  Commit failed. You may need to commit manually."
  }
  echo "✅ Changes committed"
else
  echo "ℹ️  To commit manually:"
  echo "   git add .kiro-template"
  echo "   git commit -m 'chore: Update giro template'"
fi

echo ""
echo "✨ Update complete!"
echo ""
