#!/bin/bash
# Sync spec document translations based on chat language

set -e

# Get chat language from language.md
LANGUAGE_FILE="$HOME/.kiro/steering/language.md"

if [ ! -f "$LANGUAGE_FILE" ]; then
  echo "⚠️  Language configuration not found"
  exit 0
fi

# Extract chat language
CHAT_LANG=$(grep "Agent chat language" "$LANGUAGE_FILE" | sed 's/.*: //' | tr -d '*')

# If English, no translation needed
if [ "$CHAT_LANG" = "English" ]; then
  echo "✓ Chat language is English, no translation needed"
  exit 0
fi

# Determine language code
case "$CHAT_LANG" in
  "Japanese"|"日本語")
    LANG_CODE="japanese"
    ;;
  "Chinese"|"中文")
    LANG_CODE="chinese"
    ;;
  "Korean"|"한국어")
    LANG_CODE="korean"
    ;;
  "Spanish"|"Español")
    LANG_CODE="spanish"
    ;;
  "French"|"Français")
    LANG_CODE="french"
    ;;
  "German"|"Deutsch")
    LANG_CODE="german"
    ;;
  *)
    echo "⚠️  Unsupported language: $CHAT_LANG"
    exit 0
    ;;
esac

echo "🌐 Chat language: $CHAT_LANG (code: $LANG_CODE)"

# Find all spec directories
SPEC_DIRS=$(find .kiro/specs -type d -mindepth 1 -maxdepth 2 2>/dev/null || true)

if [ -z "$SPEC_DIRS" ]; then
  echo "✓ No spec directories found"
  exit 0
fi

# Process each spec directory
for SPEC_DIR in $SPEC_DIRS; do
  echo "📁 Processing: $SPEC_DIR"
  
  # Check for English spec files
  for BASE_FILE in requirements design tasks bugfix; do
    ENGLISH_FILE="$SPEC_DIR/${BASE_FILE}.md"
    TRANSLATED_FILE="$SPEC_DIR/${BASE_FILE}_${LANG_CODE}.md"
    
    if [ -f "$ENGLISH_FILE" ]; then
      if [ ! -f "$TRANSLATED_FILE" ] || [ "$ENGLISH_FILE" -nt "$TRANSLATED_FILE" ]; then
        echo "  📝 Creating/updating: ${BASE_FILE}_${LANG_CODE}.md"
        echo "# Translation needed for ${BASE_FILE}.md" > "$TRANSLATED_FILE"
        echo "" >> "$TRANSLATED_FILE"
        echo "**Note**: This file should contain the $CHAT_LANG translation of ${BASE_FILE}.md" >> "$TRANSLATED_FILE"
        echo "" >> "$TRANSLATED_FILE"
        echo "**Status**: Translation pending" >> "$TRANSLATED_FILE"
      fi
    fi
  done
done

echo "✅ Spec translation sync complete"
