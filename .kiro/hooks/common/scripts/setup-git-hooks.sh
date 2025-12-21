#!/bin/bash

# Setup Git Hooks
# Ensure .husky directory exists and has proper permissions

set -e

echo "🔧 Setting up Git hooks..."

# Check if .husky directory exists
if [ ! -d ".husky" ]; then
  echo "❌ .husky directory not found"
  echo "   This should be in the repository root"
  exit 1
fi

# Set execute permissions on hooks
chmod +x .husky/pre-commit
chmod +x .husky/pre-push
chmod +x .husky/_/husky.sh

echo "✅ Git hooks permissions set"
echo ""
echo "Git hooks are now active:"
echo "  - pre-commit: Security checks (gitleaks)"
echo "  - pre-push: Security checks (gitleaks)"
