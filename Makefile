.PHONY: help setup install build clean setup-git-hooks pre-commit

# Default target
help:
	@echo "Available commands:"
	@echo "  make help              - Show this help message"
	@echo "  make setup             - Initial project setup (Git hooks + dependencies)"
	@echo "  make install           - Install dependencies"
	@echo "  make build             - Build MCP server"
	@echo "  make clean             - Clean build artifacts"
	@echo "  make setup-git-hooks   - Install Git hooks"
	@echo "  make pre-commit        - Run pre-commit checks"

# Initial project setup
setup: setup-git-hooks install
	@echo "✅ Project setup complete!"

# Install dependencies
install:
	@echo "📦 Installing dependencies..."
	@cd mcp/bedrock-advisor && npm ci

# Build MCP server
build:
	@echo "🔨 Building MCP server..."
	@cd mcp/bedrock-advisor && npm run build

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	@cd mcp/bedrock-advisor && rm -rf dist

# Setup Git hooks
setup-git-hooks:
	@bash .kiro/scripts/setup-git-hooks.sh

# Run pre-commit checks (called by Git hook)
pre-commit:
	@echo "🚀 Running pre-commit checks..."
	@bash .kiro/scripts/pre-commit-gitleaks.sh || exit 1
	@bash .kiro/scripts/pre-commit-filesize.sh || exit 1
	@bash .kiro/scripts/pre-commit-lint.sh || exit 1
	@echo "✅ All pre-commit checks passed!"
