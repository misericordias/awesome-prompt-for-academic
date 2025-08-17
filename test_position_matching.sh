#!/bin/bash

# Test the position-based prompt matching

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to find prompt position by title in a category file
find_prompt_position() {
    local category_file="$1"
    local target_title="$2"
    
    local position=1
    while IFS= read -r line; do
        if [[ "$line" =~ ^###[[:space:]] ]]; then
            local line_title=$(echo "$line" | sed 's/^###[[:space:]]*//')
            if [[ "$line_title" == "$target_title" ]]; then
                echo "$position"
                return 0
            fi
            ((position++))
        fi
    done < "$category_file"
    
    echo "0"  # Not found
}

# Function to get prompt by position in a category file
get_prompt_by_position() {
    local category_file="$1"
    local target_position="$2"
    
    local position=1
    local found_line=""
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^###[[:space:]] ]]; then
            if [[ $position -eq $target_position ]]; then
                found_line=$(grep -n "^$line$" "$category_file" | head -1)
                break
            fi
            ((position++))
        fi
    done < "$category_file"
    
    if [[ -n "$found_line" ]]; then
        local line_num=$(echo "$found_line" | cut -d: -f1)
        local next_prompt_line=$((line_num + 100))
        local prompt_section=$(sed -n "${line_num},${next_prompt_line}p" "$category_file")
        
        # Extract the prompt content (between ``` blocks)
        local prompt_text=$(echo "$prompt_section" | sed -n '/```/,/```/p' | sed '1d' | sed '$d')
        echo "$prompt_text"
    fi
}

# Test data
test_title="Academic Research Question Generator"
test_category="general"

echo "🧪 Testing position-based prompt matching"
echo "Title: $test_title"
echo "Category: $test_category"
echo ""

# Find position in English file
english_file="$SCRIPT_DIR/Prompts/EN/$test_category.md"
position=$(find_prompt_position "$english_file" "$test_title")

echo "📍 Position in English file: $position"

if [[ $position -eq 0 ]]; then
    echo "❌ Prompt not found in English file"
    exit 1
fi

# Test with different languages
for lang in "JP" "ZH" "DE"; do
    echo ""
    echo "🌍 Testing $lang version..."
    
    lang_file="$SCRIPT_DIR/Prompts/$lang/$test_category.md"
    
    if [[ ! -f "$lang_file" ]]; then
        echo "⚠️  $lang file not found: $lang_file"
        continue
    fi
    
    # Get prompt at the same position
    translated_prompt=$(get_prompt_by_position "$lang_file" "$position")
    
    if [[ -n "$translated_prompt" ]]; then
        echo "✅ Found $lang version at position $position"
        echo "First 100 characters: ${translated_prompt:0:100}..."
    else
        echo "❌ Could not find prompt at position $position in $lang version"
    fi
done

echo ""
echo "✅ Position-based matching test completed!"