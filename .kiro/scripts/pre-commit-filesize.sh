#!/bin/bash

# Pre-commit hook: Large file detection
# Prevents committing files larger than specified size

set -e

# File size limit in bytes (default: 50MB - GitHub warning threshold)
MAX_SIZE=${MAX_FILE_SIZE:-52428800}  # 50MB = 52428800 bytes
MAX_SIZE_MB=$((MAX_SIZE / 1048576))

echo "📏 Checking file sizes (max: ${MAX_SIZE_MB}MB)..."

# Get staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM || true)

if [ -z "$STAGED_FILES" ]; then
    echo "ℹ️  No files to check"
    exit 0
fi

LARGE_FILES=()
TOTAL_SIZE=0

# Check each staged file
while IFS= read -r file; do
    if [ -f "$file" ]; then
        FILE_SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
        TOTAL_SIZE=$((TOTAL_SIZE + FILE_SIZE))
        
        if [ "$FILE_SIZE" -gt "$MAX_SIZE" ]; then
            FILE_SIZE_MB=$(echo "scale=2; $FILE_SIZE / 1048576" | bc)
            LARGE_FILES+=("$file (${FILE_SIZE_MB}MB)")
        fi
    fi
done <<< "$STAGED_FILES"

# Report results
if [ ${#LARGE_FILES[@]} -gt 0 ]; then
    echo ""
    echo "❌ Commit blocked: Large files detected"
    echo ""
    echo "Files exceeding ${MAX_SIZE_MB}MB:"
    for file in "${LARGE_FILES[@]}"; do
        echo "  - $file"
    done
    echo ""
    echo "How to fix:"
    echo "1. Remove large files from commit: git reset HEAD <file>"
    echo "2. Use Git LFS for large files: git lfs track <file>"
    echo "3. Add to .gitignore if not needed in repository"
    echo "4. Compress or optimize the file"
    echo ""
    echo "To override (not recommended):"
    echo "  MAX_FILE_SIZE=10485760 git commit  # 10MB limit"
    echo ""
    exit 1
fi

# Show total size
TOTAL_SIZE_MB=$(echo "scale=2; $TOTAL_SIZE / 1048576" | bc)
echo "✅ All files within size limit (total: ${TOTAL_SIZE_MB}MB)"
exit 0
