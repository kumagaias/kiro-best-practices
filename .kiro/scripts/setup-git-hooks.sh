#!/bin/bash

# Setup Git hooks for pre-commit checks
# Run this script to install Git hooks in your project

set -e

echo "🔧 Setting up Git hooks..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Run 'git init' first."
    exit 1
fi

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# Pre-commit hook: Run all checks via Makefile
set -e

make pre-commit
EOF

chmod +x .git/hooks/pre-commit

echo "✅ Git hooks installed successfully!"
echo ""
echo "Installed hooks:"
echo "  - .git/hooks/pre-commit"
echo ""
echo "Checks enabled:"
echo "  1. Gitleaks (secret scanning)"
echo "  2. Large file detection (50MB limit)"
echo "  3. ESLint/Prettier/npm audit"
echo ""
echo "To skip hooks (not recommended):"
echo "  git commit --no-verify"
echo ""
