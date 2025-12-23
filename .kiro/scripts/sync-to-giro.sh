#!/bin/bash

# Sync improvements from this project back to giro template repository
# Usage: 
#   GIRO_PATH=~/projects/giro ./.kiro/scripts/sync-to-giro.sh

set -e

GIRO_PATH="${GIRO_PATH:-$HOME/projects/giro}"

echo "🔄 Syncing improvements to giro template..."
echo ""

# Check if giro repository exists
if [ ! -d "$GIRO_PATH" ]; then
  echo "❌ giro repository not found at: $GIRO_PATH"
  echo ""
  echo "Options:"
  echo "  1. Clone giro: git clone https://github.com/kumagaias/giro $GIRO_PATH"
  echo "  2. Set custom path: GIRO_PATH=/path/to/giro ./.kiro/scripts/sync-to-giro.sh"
  exit 1
fi

if [ ! -d "$GIRO_PATH/.git" ]; then
  echo "❌ $GIRO_PATH is not a git repository"
  exit 1
fi

# Show what will be synced
echo "📋 Files to sync:"
echo "  ✓ .kiro/hooks/"
echo "  ✓ .kiro/steering/common/"
echo "  ✓ .kiro/steering-examples/"
echo "  ✓ .kiro/settings/ (templates only)"
echo "  ✓ .kiro/scripts/"
echo ""

read -p "Continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 0
fi

# Copy common files
echo "📁 Copying files..."

cp -r .kiro/hooks "$GIRO_PATH/.kiro/" 2>/dev/null || true
cp -r .kiro/steering/common "$GIRO_PATH/.kiro/steering/" 2>/dev/null || true
cp -r .kiro/steering-examples "$GIRO_PATH/.kiro/" 2>/dev/null || true
cp .kiro/settings/mcp.json "$GIRO_PATH/.kiro/settings/" 2>/dev/null || true
cp .kiro/settings/mcp.local.json.example "$GIRO_PATH/.kiro/settings/" 2>/dev/null || true
cp -r .kiro/scripts "$GIRO_PATH/.kiro/" 2>/dev/null || true

echo "✅ Files synced to: $GIRO_PATH"
echo ""

# Show git status
cd "$GIRO_PATH"
if git diff --quiet; then
  echo "ℹ️  No changes detected"
else
  echo "📋 Changes detected:"
  git status --short
  echo ""
  echo "📋 Next steps:"
  echo "  cd $GIRO_PATH"
  echo "  git diff          # Review changes"
  echo "  git add ."
  echo "  git commit -m 'feat: Improve from $(basename $(pwd))'"
  echo "  git push"
fi
