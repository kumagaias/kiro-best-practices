#!/bin/bash

# Kiro Best Practices Uninstaller
# Removes shared configuration from ~/.kiro/
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kumagaias/kiro-best-practices/main/uninstall.sh | bash

set -e

KIRO_HOME="$HOME/.kiro"
REPO_DIR="$KIRO_HOME/kiro-best-practices"

# Check if running in non-interactive mode (piped from curl)
if [ -t 0 ]; then
  INTERACTIVE=true
else
  INTERACTIVE=false
fi

echo "🗑️  Kiro Best Practices Uninstaller"
echo "===================================="
echo ""

if [ ! -d "$KIRO_HOME" ]; then
  echo "ℹ️  ~/.kiro directory not found. Nothing to uninstall."
  exit 0
fi

echo "⚠️  This will remove:"
echo "  - $REPO_DIR"
echo "  - ~/.kiro/hooks/"
echo "  - ~/.kiro/settings/"
echo "  - ~/.kiro/steering/"
echo "  - ~/.kiro/scripts/"
echo "  - ~/.kiro/agents/"
echo ""
echo "⚠️  Your project-specific .kiro/ directories will NOT be affected."
echo ""

if [ "$INTERACTIVE" = true ]; then
  read -p "Continue? (y/N): " -n 1 -r
  echo ""
  
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
  fi
else
  echo "⚠️  Running in non-interactive mode. Proceeding with uninstallation..."
  echo ""
fi

echo ""
echo "🗑️  Removing files and symlinks..."

# Remove all symlinks and files in known directories
for dir in hooks settings steering scripts agents; do
  if [ -d "$KIRO_HOME/$dir" ]; then
    echo "  📁 Cleaning $dir/..."
    find "$KIRO_HOME/$dir" -type l -exec rm -f {} \;
    find "$KIRO_HOME/$dir" -type f -exec rm -f {} \;
    echo "  ✓ Cleaned $dir/"
  fi
done

# Remove repository
if [ -d "$REPO_DIR" ]; then
  rm -rf "$REPO_DIR"
  echo "  ✓ Removed repository"
fi

# Remove empty directories
for dir in hooks settings steering scripts agents; do
  rmdir "$KIRO_HOME/$dir" 2>/dev/null && echo "  ✓ Removed $dir directory" || true
done

echo ""
echo "✅ Uninstallation complete!"
echo ""
echo "💡 Note: Your project-specific .kiro/ directories were not removed."
echo ""
