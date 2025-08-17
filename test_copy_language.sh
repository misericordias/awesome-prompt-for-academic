#!/bin/bash

# Simple test for the copy language functionality
# This simulates the key parts of the copy_language_prompt function

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Test data
test_title="Academic Research Question Generator"
test_category="general"
test_language="JP"

echo "Testing copy language functionality..."
echo "Title: $test_title"
echo "Category: $test_category"
echo "Target Language: $test_language"
echo ""

# Check if the language folder exists
language_dir="$SCRIPT_DIR/Prompts/$test_language"
if [[ ! -d "$language_dir" ]]; then
    echo "❌ Language folder for $test_language not found at $language_dir"
    exit 1
fi

# Check if the category file exists in the language folder
language_category_file="$language_dir/$test_category.md"
if [[ ! -f "$language_category_file" ]]; then
    echo "❌ Category file for $test_language not found: $language_category_file"
    exit 1
fi

# Search for the prompt in the language file by title
escaped_title=$(echo "$test_title" | sed 's/[[\.*^$()+?{|]/\\&/g')
prompt_line=$(grep -n "^### .*$escaped_title" "$language_category_file" 2>/dev/null || true)

if [[ -z "$prompt_line" ]]; then
    echo "❌ Prompt '$test_title' not found in $test_language version of $test_category"
    exit 1
fi

echo "✅ Found prompt line: $prompt_line"

# Extract the prompt content
line_num=$(echo "$prompt_line" | cut -d: -f1)
next_prompt_line=$((line_num + 100))
prompt_section=$(sed -n "${line_num},${next_prompt_line}p" "$language_category_file")

# Extract the prompt content (between ``` blocks)
translated_prompt=$(echo "$prompt_section" | sed -n '/```/,/```/p' | sed '1d' | sed '$d')

if [[ -z "$translated_prompt" ]]; then
    echo "❌ Could not extract prompt content from $test_language version"
    exit 1
fi

echo "✅ Successfully extracted translated prompt:"
echo "---"
echo "$translated_prompt"
echo "---"
echo ""
echo "✅ Copy language functionality test passed!"