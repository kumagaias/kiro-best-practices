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
echo "  - ~/.kiro/templates/"
echo "  - ~/.kiro/docs/"
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
echo "🗑️  Removing files..."

# Remove copied files
rm -f "$KIRO_HOME/hooks/pre-commit-security.json" 2>/dev/null && echo "  ✓ Removed hooks/pre-commit-security.json" || true
rm -f "$KIRO_HOME/hooks/run-all-tests.json" 2>/dev/null && echo "  ✓ Removed hooks/run-all-tests.json" || true
rm -f "$KIRO_HOME/hooks/run-tests.json" 2>/dev/null && echo "  ✓ Removed hooks/run-tests.json" || true
rm -f "$KIRO_HOME/hooks/commit-push-pr.json" 2>/dev/null && echo "  ✓ Removed hooks/commit-push-pr.json" || true
rm -f "$KIRO_HOME/hooks/documentation-update-reminder.json" 2>/dev/null && echo "  ✓ Removed hooks/documentation-update-reminder.json" || true
rm -f "$KIRO_HOME/hooks/setup-on-session-start.json" 2>/dev/null && echo "  ✓ Removed hooks/setup-on-session-start.json" || true

rm -f "$KIRO_HOME/settings/mcp.json" 2>/dev/null && echo "  ✓ Removed settings/mcp.json" || true
rm -f "$KIRO_HOME/settings/mcp.local.json.example" 2>/dev/null && echo "  ✓ Removed settings/mcp.local.json.example" || true

rm -f "$KIRO_HOME/steering/project.md" 2>/dev/null && echo "  ✓ Removed steering/project.md" || true
rm -f "$KIRO_HOME/steering/tech.md" 2>/dev/null && echo "  ✓ Removed steering/tech.md" || true
rm -f "$KIRO_HOME/steering/deployment-workflow.md" 2>/dev/null && echo "  ✓ Removed steering/deployment-workflow.md" || true
rm -f "$KIRO_HOME/steering/language.md" 2>/dev/null && echo "  ✓ Removed steering/language.md" || true

rm -f "$KIRO_HOME/scripts/security-check.sh" 2>/dev/null && echo "  ✓ Removed scripts/security-check.sh" || true

# Remove repository
if [ -d "$REPO_DIR" ]; then
  rm -rf "$REPO_DIR"
  echo "  ✓ Removed repository"
fi

# Remove empty directories
rmdir "$KIRO_HOME/hooks" 2>/dev/null && echo "  ✓ Removed hooks directory" || true
rmdir "$KIRO_HOME/settings" 2>/dev/null && echo "  ✓ Removed settings directory" || true
rmdir "$KIRO_HOME/steering" 2>/dev/null && echo "  ✓ Removed steering directory" || true
rmdir "$KIRO_HOME/scripts" 2>/dev/null && echo "  ✓ Removed scripts directory" || true

echo ""
echo "✅ Uninstallation complete!"
echo ""
echo "💡 Note: Your project-specific .kiro/ directories were not removed."
echo ""
