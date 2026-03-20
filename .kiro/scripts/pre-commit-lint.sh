#!/bin/bash

# Pre-commit hook: ESLint and Prettier
# Ensures code quality and formatting before commit

set -e

echo "🔍 Running code quality checks..."

# Get staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(ts|tsx|js|jsx)$' || true)

if [ -z "$STAGED_FILES" ]; then
    echo "ℹ️  No TypeScript/JavaScript files to check"
    exit 0
fi

echo "📝 Found files to check:"
echo "$STAGED_FILES" | sed 's/^/  - /'
echo ""

# Check if we're in a Node.js project
if [ ! -f "package.json" ]; then
    echo "ℹ️  No package.json found, skipping lint checks"
    exit 0
fi

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "⚠️  node_modules not found. Run 'npm install' first."
    exit 1
fi

# Run npm audit for high/critical vulnerabilities
echo "🔒 Checking for security vulnerabilities..."
if npm audit --audit-level=high > /dev/null 2>&1; then
    echo "✅ No high/critical vulnerabilities found"
else
    echo ""
    echo "❌ Commit blocked: High or critical vulnerabilities detected"
    echo ""
    npm audit --audit-level=high
    echo ""
    echo "How to fix:"
    echo "  npm audit fix"
    echo "  npm audit fix --force (if needed)"
    echo ""
    exit 1
fi

# Run Prettier check
if [ -f "node_modules/.bin/prettier" ]; then
    echo "🎨 Checking code formatting with Prettier..."
    if echo "$STAGED_FILES" | xargs npx prettier --check; then
        echo "✅ Prettier check passed"
    else
        echo ""
        echo "❌ Commit blocked: Code formatting issues detected"
        echo ""
        echo "How to fix:"
        echo "  npx prettier --write <file>"
        echo "  Or run: npx prettier --write ."
        echo ""
        exit 1
    fi
else
    echo "ℹ️  Prettier not installed, skipping format check"
fi

# Run ESLint
if [ -f "node_modules/.bin/eslint" ]; then
    echo "🔎 Running ESLint..."
    if echo "$STAGED_FILES" | xargs npx eslint; then
        echo "✅ ESLint check passed"
    else
        echo ""
        echo "❌ Commit blocked: ESLint errors detected"
        echo ""
        echo "How to fix:"
        echo "  npx eslint --fix <file>"
        echo "  Or run: npx eslint --fix ."
        echo ""
        exit 1
    fi
else
    echo "ℹ️  ESLint not installed, skipping lint check"
fi

echo ""
echo "✅ All code quality checks passed"
exit 0
