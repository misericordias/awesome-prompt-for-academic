#!/bin/bash

# Debug script to test language functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_FILE="$SCRIPT_DIR/Profiles/user_profile.conf"

# Load language strings
source "$SCRIPT_DIR/Profiles/language_strings.sh" 2>/dev/null || true

# Function to read profile value
read_profile_value() {
    local key="$1"
    local default_value="$2"
    
    if [[ -f "$PROFILE_FILE" ]]; then
        local value=$(grep "^$key=" "$PROFILE_FILE" | cut -d'=' -f2 | cut -d'#' -f1 | tr -d ' ')
        if [[ -n "$value" ]]; then
            echo "$value"
        else
            echo "$default_value"
        fi
    else
        echo "$default_value"
    fi
}

echo "=== Language Debug Test ==="
echo "Profile file: $PROFILE_FILE"
echo "Profile file exists: $(test -f "$PROFILE_FILE" && echo "YES" || echo "NO")"

if [[ -f "$PROFILE_FILE" ]]; then
    echo "Profile contents:"
    cat "$PROFILE_FILE"
    echo ""
fi

echo "Interface language setting: $(read_profile_value "INTERFACE_LANGUAGE" "EN")"
echo ""

interface_lang=$(read_profile_value "INTERFACE_LANGUAGE" "EN")
echo "Testing get_string function:"
echo "SIMPLE_SEARCH_OPTIONS (EN): $(get_string "SIMPLE_SEARCH_OPTIONS" "EN")"
echo "SIMPLE_SEARCH_OPTIONS (ZH): $(get_string "SIMPLE_SEARCH_OPTIONS" "ZH")"
echo "SIMPLE_SEARCH_OPTIONS (current): $(get_string "SIMPLE_SEARCH_OPTIONS" "$interface_lang")"
echo ""

echo "Testing other strings:"
echo "INTERACTIVE_SEARCH_RECOMMENDED (ZH): $(get_string "INTERACTIVE_SEARCH_RECOMMENDED" "ZH")"
echo "QUICK_KEYWORD_SEARCH (ZH): $(get_string "QUICK_KEYWORD_SEARCH" "ZH")"
echo "BROWSE_ALL_CATEGORIES (ZH): $(get_string "BROWSE_ALL_CATEGORIES" "ZH")"