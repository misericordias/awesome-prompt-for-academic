#!/opt/homebrew/bin/bash

# Prompt Search CLI Tool
# Search academic prompts by keywords, tags, categories, and more

set -euo pipefail

# Colors for better UX
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Script directory (parent of scripts folder)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/Prompts/EN"
README_FILE="$SCRIPT_DIR/README.md"
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

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    local show_colors=$(read_profile_value "SHOW_COLORS" "true")
    
    if [[ "$show_colors" == "true" ]]; then
        echo -e "${color}${message}${NC}"
    else
        echo "$message"
    fi
}

# Function to detect clipboard command for the current OS
get_clipboard_command() {
    if command -v pbcopy >/dev/null 2>&1; then
        echo "pbcopy"  # macOS
    elif command -v xclip >/dev/null 2>&1; then
        echo "xclip -selection clipboard"  # Linux with xclip
    elif command -v xsel >/dev/null 2>&1; then
        echo "xsel --clipboard --input"  # Linux with xsel
    elif command -v clip.exe >/dev/null 2>&1; then
        echo "clip.exe"  # Windows with clip.exe
    else
        echo ""
    fi
}

# Function to copy text to clipboard
copy_to_clipboard() {
    local text="$1"
    local clipboard_cmd=$(get_clipboard_command)
    
    if [[ -z "$clipboard_cmd" ]]; then
        print_color "$RED" "Error: No clipboard command found. Please install one of:"
        echo "  - macOS: pbcopy (built-in)"
        echo "  - Linux: xclip or xsel"
        echo "  - Windows: clip.exe (built-in)"
        return 1
    fi
    
    echo "$text" | eval "$clipboard_cmd"
    if [[ $? -eq 0 ]]; then
        print_color "$GREEN" "✅ Prompt copied to clipboard successfully!"
        return 0
    else
        print_color "$RED" "Error: Failed to copy to clipboard"
        return 1
    fi
}

# Function to extract prompt content (main part only)
extract_prompt_content() {
    local file="$1"
    local prompt_number="$2"
    
    # Find the prompt section - look for the main prompt (not nested ones)
    local prompt_start=$(grep -n "^### $prompt_number\." "$file" | head -n1 | cut -d: -f1)
    if [[ -z "$prompt_start" ]]; then
        return 1
    fi
    
    # Find the next main prompt or end of file
    local next_prompt=$(grep -n "^### [0-9]\." "$file" | grep -A1 "^$prompt_start:" | tail -n1 | cut -d: -f1)
    if [[ -z "$next_prompt" ]]; then
        # If no next prompt, read to end of file
        local prompt_end=$(wc -l < "$file")
    else
        local prompt_end=$((next_prompt - 1))
    fi
    
    # Extract the prompt section
    local prompt_section=$(sed -n "${prompt_start},${prompt_end}p" "$file")
    
    # Extract only the prompt content (between ``` blocks)
    local prompt_content=$(echo "$prompt_section" | sed -n '/```/,/```/p' | sed '1d' | sed '$d')
    
    # If no code blocks found, fall back to removing title, tags, and description
    if [[ -z "$prompt_content" ]]; then
        prompt_content=$(echo "$prompt_section" | sed '/^### [0-9]/d' | sed '/^\*\*Tags:\*\*/d' | sed '/^\*\*Description:\*\*/d' | sed '/^[[:space:]]*$/d')
    fi
    
    # Check if content is empty or only contains whitespace
    if [[ -z "$prompt_content" ]] || [[ "$prompt_content" =~ ^[[:space:]]*$ ]]; then
        return 1
    fi
    
    echo "$prompt_content"
}

# Function to copy prompt to clipboard
copy_prompt_to_clipboard() {
    local prompt_number="$1"
    local language="${2:-EN}"
    local category="${3:-}"
    
    # For now, we'll extract from README.md since that's where the actual prompts are
    if [[ ! -f "$README_FILE" ]]; then
        print_color "$RED" "Error: README.md file not found at $README_FILE"
        return 1
    fi
    
    # Extract prompt content from README.md
    local prompt_content=$(extract_prompt_content "$README_FILE" "$prompt_number")
    local extract_result=$?
    
    if [[ $extract_result -eq 0 ]] && [[ -n "$prompt_content" ]]; then
        print_color "$BLUE" "Found prompt $prompt_number in README.md"
        copy_to_clipboard "$prompt_content"
    else
        print_color "$RED" "Error: Prompt $prompt_number not found in README.md"
        return 1
    fi
    
    # Note: Language and category support will be implemented when actual prompt files are created
    if [[ "$language" != "EN" ]] || [[ -n "$category" ]]; then
        print_color "$YELLOW" "Note: Language and category filtering not yet implemented. Extracting from README.md"
    fi
}

# Function to show usage
show_usage() {
    print_color "$BLUE" "🔍 Prompt Search CLI Tool"
    echo ""
    echo "Usage: $0 [OPTIONS] [KEYWORDS...]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -c, --category CATEGORY Search in specific category file"
    echo "  -t, --tag TAG           Search by specific tag"
    echo "  -a, --area AREA         Search by research area"
    echo "  -i, --interactive       Interactive search mode"
    echo "  -l, --list-categories   List all available categories"
    echo "  -v, --verbose           Show detailed results"
    echo "  --case-sensitive        Case-sensitive search"
    echo "  --exact-match           Exact phrase matching"
    echo "  --copy PROMPT_NUM       Copy specific prompt to clipboard"
    echo "  --lang LANGUAGE         Language for prompt (default: EN)"
    echo ""
    echo "Examples:"
    echo "  $0 machine learning                    # Search for 'machine learning'"
    echo "  $0 -c computer-science neural          # Search 'neural' in computer science"
    echo "  $0 -t 'Data Analysis' statistics       # Search by tag and keyword"
    echo "  $0 -i                                  # Interactive mode"
    echo "  $0 --exact-match 'literature review'  # Exact phrase search"
    echo "  $0 --copy 1                            # Copy prompt 1 to clipboard"
    echo "  $0 --copy 5 --lang ZH                 # Copy prompt 5 in Chinese to clipboard"
    echo "  $0 --copy 3 -c computer-science       # Copy prompt 3 from computer-science to clipboard"
    echo ""
}

# Function to list categories
list_categories() {
    print_color "$BLUE" "📂 Available Categories:"
    echo ""
    
    if [[ ! -d "$PROMPTS_DIR" ]]; then
        print_color "$RED" "Error: Prompts directory not found at $PROMPTS_DIR"
        exit 1
    fi
    
    local count=1
    for file in "$PROMPTS_DIR"/*.md; do
        if [[ -f "$file" ]]; then
            local category=$(basename "$file" .md)
            local title=$(head -n 1 "$file" | sed 's/^# //')
            printf "%2d. %-25s %s\n" "$count" "$category" "($title)"
            ((count++))
        fi
    done
    echo ""
}

# Function to extract prompt info
extract_prompt_info() {
    local file="$1"
    local line_num="$2"
    local context_lines="${3:-5}"
    
    # Get the prompt title (current line)
    local title=$(sed -n "${line_num}p" "$file")
    
    # Get the next few lines for tags and description
    local end_line=$((line_num + context_lines))
    local content=$(sed -n "${line_num},${end_line}p" "$file")
    
    echo "$content"
}

# Function to search in a specific file
search_in_file() {
    local file="$1"
    local search_terms=("${@:2}")
    local category=$(basename "$file" .md)
    local found_results=0
    
    # Build grep pattern
    local grep_pattern=""
    local grep_options="-n"
    
    if [[ "$CASE_SENSITIVE" == "false" ]]; then
        grep_options="$grep_options -i"
    fi
    
    if [[ "$EXACT_MATCH" == "true" ]]; then
        # For exact match, join terms with spaces
        grep_pattern=$(IFS=' '; echo "${search_terms[*]}")
    else
        # For flexible search, create pattern that matches any term
        grep_pattern=$(IFS='|'; echo "${search_terms[*]}")
    fi
    
    # Search for prompts (lines starting with ###)
    local prompt_lines=$(grep -n "^### [0-9]" "$file" 2>/dev/null || true)
    
    if [[ -z "$prompt_lines" ]]; then
        return 0
    fi
    
    # Check each prompt
    while IFS= read -r prompt_line; do
        local line_num=$(echo "$prompt_line" | cut -d: -f1)
        local next_prompt_line=$((line_num + 20)) # Look ahead 20 lines for content
        
        # Extract the prompt section
        local prompt_section=$(sed -n "${line_num},${next_prompt_line}p" "$file")
        
        # Check if search terms match in this section
        local matches=false
        if [[ "$EXACT_MATCH" == "true" ]]; then
            if echo "$prompt_section" | grep -q $grep_options "$grep_pattern"; then
                matches=true
            fi
        else
            # Check if any search term matches
            for term in "${search_terms[@]}"; do
                if echo "$prompt_section" | grep -q $grep_options "$term"; then
                    matches=true
                    break
                fi
            done
        fi
        
        if [[ "$matches" == "true" ]]; then
            ((found_results++))
            
            # Extract and display the result
            local title=$(echo "$prompt_line" | cut -d: -f2-)
            print_color "$GREEN" "📍 Found in $category:"
            print_color "$CYAN" "$title"
            
            if [[ "$VERBOSE" == "true" ]]; then
                # Show more details
                local tags_line=$(sed -n "$((line_num + 2))p" "$file" 2>/dev/null || echo "")
                local desc_line=$(sed -n "$((line_num + 4))p" "$file" 2>/dev/null || echo "")
                
                if [[ "$tags_line" =~ \*\*Tags:\*\* ]]; then
                    print_color "$YELLOW" "  $tags_line"
                fi
                if [[ "$desc_line" =~ \*\*Description:\*\* ]]; then
                    echo "  $desc_line"
                fi
                
                # Show matching lines with context
                echo ""
                print_color "$MAGENTA" "  Matching content:"
                local matching_lines=$(echo "$prompt_section" | grep $grep_options -C 1 "$grep_pattern" 2>/dev/null || true)
                if [[ -n "$matching_lines" ]]; then
                    echo "$matching_lines" | sed 's/^/    /'
                fi
            fi
            
            echo ""
        fi
    done <<< "$prompt_lines"
    
    return $found_results
}

# Function for interactive search
interactive_search() {
    print_color "$BLUE" "🔍 Interactive Prompt Search"
    echo ""
    
    while true; do
        echo -n "Enter search keywords (or 'quit' to exit): "
        read -r keywords </dev/tty
        
        if [[ "$keywords" == "quit" ]] || [[ "$keywords" == "q" ]]; then
            print_color "$GREEN" "Goodbye!"
            break
        fi
        
        if [[ -z "$keywords" ]]; then
            print_color "$YELLOW" "Please enter some keywords to search."
            continue
        fi
        
        echo ""
        print_color "$BLUE" "Searching for: '$keywords'"
        echo ""
        
        # Convert keywords to array
        read -ra search_terms <<< "$keywords"
        
        # Perform search
        local total_results=0
        for file in "$PROMPTS_DIR"/*.md; do
            if [[ -f "$file" ]]; then
                search_in_file "$file" "${search_terms[@]}"
                total_results=$((total_results + $?))
            fi
        done
        
        if [[ $total_results -eq 0 ]]; then
            print_color "$YELLOW" "No results found for '$keywords'"
        else
            print_color "$GREEN" "Found $total_results result(s)"
        fi
        
        echo ""
        echo "----------------------------------------"
        echo ""
    done
}

# Function to search by tag
search_by_tag() {
    local tag="$1"
    local total_results=0
    
    print_color "$BLUE" "🏷️  Searching by tag: '$tag'"
    echo ""
    
    for file in "$PROMPTS_DIR"/*.md; do
        if [[ -f "$file" ]]; then
            local category=$(basename "$file" .md)
            
            # Search for the tag in **Tags:** lines
            local tag_matches=$(grep -n "**Tags:**.*$tag" "$file" 2>/dev/null || true)
            
            if [[ -n "$tag_matches" ]]; then
                while IFS= read -r tag_line; do
                    local line_num=$(echo "$tag_line" | cut -d: -f1)
                    # Find the corresponding prompt title (should be 2 lines above)
                    local title_line_num=$((line_num - 2))
                    local title=$(sed -n "${title_line_num}p" "$file" 2>/dev/null || echo "")
                    
                    if [[ "$title" =~ ^### ]]; then
                        ((total_results++))
                        print_color "$GREEN" "📍 Found in $category:"
                        print_color "$CYAN" "$title"
                        print_color "$YELLOW" "  $(echo "$tag_line" | cut -d: -f2-)"
                        
                        if [[ "$VERBOSE" == "true" ]]; then
                            local desc_line=$(sed -n "$((line_num + 2))p" "$file" 2>/dev/null || echo "")
                            if [[ "$desc_line" =~ \*\*Description:\*\* ]]; then
                                echo "  $desc_line"
                            fi
                        fi
                        echo ""
                    fi
                done <<< "$tag_matches"
            fi
        fi
    done
    
    if [[ $total_results -eq 0 ]]; then
        print_color "$YELLOW" "No prompts found with tag '$tag'"
    else
        print_color "$GREEN" "Found $total_results result(s) with tag '$tag'"
    fi
}

# Function to search by research area
search_by_area() {
    local area="$1"
    local total_results=0
    
    print_color "$BLUE" "🔬 Searching by research area: '$area'"
    echo ""
    
    for file in "$PROMPTS_DIR"/*.md; do
        if [[ -f "$file" ]]; then
            local category=$(basename "$file" .md)
            
            # Check if this area exists in the file's research areas section
            local area_exists=$(sed -n '/## Research Areas/,/^## /p' "$file" | grep -i "- $area" 2>/dev/null || true)
            
            if [[ -n "$area_exists" ]]; then
                print_color "$GREEN" "📂 Category: $category contains research area '$area'"
                
                # Find all prompts in this category
                local prompt_lines=$(grep -n "^### [0-9]" "$file" 2>/dev/null || true)
                local prompt_count=$(echo "$prompt_lines" | wc -l)
                
                if [[ $prompt_count -gt 0 ]]; then
                    echo "  Found $prompt_count prompt(s) in this category:"
                    
                    if [[ "$VERBOSE" == "true" ]]; then
                        while IFS= read -r prompt_line; do
                            local title=$(echo "$prompt_line" | cut -d: -f2-)
                            print_color "$CYAN" "    $title"
                            ((total_results++))
                        done <<< "$prompt_lines"
                    else
                        total_results=$((total_results + prompt_count))
                    fi
                fi
                echo ""
            fi
        fi
    done
    
    if [[ $total_results -eq 0 ]]; then
        print_color "$YELLOW" "No prompts found in research area '$area'"
    else
        print_color "$GREEN" "Found $total_results result(s) in research area '$area'"
    fi
}

# Main function
main() {
    # Default options
    local CATEGORY=""
    local TAG=""
    local AREA=""
    local INTERACTIVE=false
    local LIST_CATEGORIES=false
    VERBOSE=false
    CASE_SENSITIVE=false
    EXACT_MATCH=false
    local COPY_PROMPT_NUM=""
    local LANGUAGE="EN"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -c|--category)
                CATEGORY="$2"
                shift 2
                ;;
            -t|--tag)
                TAG="$2"
                shift 2
                ;;
            -a|--area)
                AREA="$2"
                shift 2
                ;;
            -i|--interactive)
                INTERACTIVE=true
                shift
                ;;
            -l|--list-categories)
                LIST_CATEGORIES=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            --case-sensitive)
                CASE_SENSITIVE=true
                shift
                ;;
            --exact-match)
                EXACT_MATCH=true
                shift
                ;;
            --copy)
                COPY_PROMPT_NUM="$2"
                shift 2
                ;;
            --lang)
                LANGUAGE="$2"
                shift 2
                ;;
            -*)
                print_color "$RED" "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                break
                ;;
        esac
    done
    
    # Check if prompts directory exists
    if [[ ! -d "$PROMPTS_DIR" ]]; then
        print_color "$RED" "Error: Prompts directory not found at $PROMPTS_DIR"
        exit 1
    fi
    
    # Handle special modes
    if [[ "$LIST_CATEGORIES" == "true" ]]; then
        list_categories
        exit 0
    fi
    
    if [[ "$INTERACTIVE" == "true" ]]; then
        interactive_search
        exit 0
    fi
    
    # Handle tag search
    if [[ -n "$TAG" ]]; then
        search_by_tag "$TAG"
        exit 0
    fi
    
    # Handle area search
    if [[ -n "$AREA" ]]; then
        search_by_area "$AREA"
        exit 0
    fi
    
    # Handle copy prompt
    if [[ -n "$COPY_PROMPT_NUM" ]]; then
        copy_prompt_to_clipboard "$COPY_PROMPT_NUM" "$LANGUAGE" "$CATEGORY"
        exit 0
    fi
    
    # Regular keyword search
    if [[ $# -eq 0 ]]; then
        print_color "$YELLOW" "No search terms provided. Use -h for help or -i for interactive mode."
        exit 1
    fi
    
    local search_terms=("$@")
    local total_results=0
    
    print_color "$BLUE" "🔍 Searching for: $(IFS=' '; echo "${search_terms[*]}")"
    if [[ "$EXACT_MATCH" == "true" ]]; then
        print_color "$YELLOW" "Using exact phrase matching"
    fi
    if [[ "$CASE_SENSITIVE" == "true" ]]; then
        print_color "$YELLOW" "Using case-sensitive search"
    fi
    echo ""
    
    # Search in specific category or all categories
    if [[ -n "$CATEGORY" ]]; then
        local category_file="$PROMPTS_DIR/$CATEGORY.md"
        if [[ -f "$category_file" ]]; then
            search_in_file "$category_file" "${search_terms[@]}"
            total_results=$?
        else
            print_color "$RED" "Category file not found: $category_file"
            exit 1
        fi
    else
        # Search in all categories
        for file in "$PROMPTS_DIR"/*.md; do
            if [[ -f "$file" ]]; then
                search_in_file "$file" "${search_terms[@]}"
                total_results=$((total_results + $?))
            fi
        done
    fi
    
    # Summary
    echo "----------------------------------------"
    if [[ $total_results -eq 0 ]]; then
        print_color "$YELLOW" "No results found"
    else
        print_color "$GREEN" "Total results found: $total_results"
    fi
}

# Run main function
main "$@"