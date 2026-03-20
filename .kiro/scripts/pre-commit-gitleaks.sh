#!/bin/bash

# Pre-commit hook: Gitleaks security scan
# Prevents commits containing sensitive information

set -e

echo "🔒 Running gitleaks security scan..."

# Check if gitleaks is installed
if ! command -v gitleaks &> /dev/null; then
    echo "❌ gitleaks is not installed"
    echo ""
    echo "Installation instructions:"
    echo "  macOS: brew install gitleaks"
    echo "  Linux: https://github.com/gitleaks/gitleaks#installing"
    echo ""
    echo "⚠️  Commit blocked: Install gitleaks to continue"
    exit 1
fi

# Scan staged files
if gitleaks protect --staged --verbose --redact; then
    echo "✅ No secrets detected"
    exit 0
else
    echo ""
    echo "❌ Commit blocked: Sensitive information detected"
    echo ""
    echo "How to fix:"
    echo "1. Remove sensitive information from detected files"
    echo "2. Move secrets to environment variables or secure config"
    echo "3. Add false positives to .gitleaksignore (use sparingly)"
    echo ""
    exit 1
fi
