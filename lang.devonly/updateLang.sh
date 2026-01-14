#!/bin/bash
# Script to update all language files in assets/minecraft/lang from the template

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/en_us.json"
TARGET_DIR="$SCRIPT_DIR/../assets/minecraft/lang"

if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Source file not found: $SOURCE_FILE"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory not found: $TARGET_DIR"
    exit 1
fi

echo "Updating language files from $SOURCE_FILE"
echo "Target directory: $TARGET_DIR"
echo ""

# Copy content to all JSON files in the target directory
for file in "$TARGET_DIR"/*.json; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "Updating: $filename"
        cp "$SOURCE_FILE" "$file"
    fi
done

echo ""
echo "Language files updated successfully!"
