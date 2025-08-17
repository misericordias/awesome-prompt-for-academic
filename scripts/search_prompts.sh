#!/opt/homebrew/bin/bash

# Simple Prompt Search Tool
# Search academic prompts by keywords across all categories

# Disabled strict error handling to prevent early exit on search results
# set -euo pipefail

# Colors for better UX
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/Prompts/EN"
README_FILE="$SCRIPT_DIR/README.md"

# Global variable for search results
SEARCH_RESULTS_COUNT=0
SEARCH_RESULTS_TITLES=()
SEARCH_RESULTS_FILES=()
SEARCH_RESULTS_LINES=()

# Function to clear search results
clear_search_results() {
    SEARCH_RESULTS_COUNT=0
    SEARCH_RESULTS_TITLES=()
    SEARCH_RESULTS_FILES=()
    SEARCH_RESULTS_LINES=()
}

# Function to add search results
add_search_results() {
    # Append the new results to global arrays
    SEARCH_RESULTS_TITLES+=("$1")
    SEARCH_RESULTS_FILES+=("$2")
    SEARCH_RESULTS_LINES+=("$3")
    
    # Update the count
    SEARCH_RESULTS_COUNT=${#SEARCH_RESULTS_TITLES[@]}
}

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
        echo -e "${color}${message}${NC}"
}

# Function to show usage
show_usage() {
    print_color "$BLUE" "🔍 Simple Prompt Search Tool"
    echo ""
    echo "Usage: $0 [OPTIONS] [KEYWORDS...]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -i, --interactive       Interactive search mode"
    echo "  -l, --list-categories   List all available categories"
    echo "  -b, --browse-categories Browse prompts by category"
    echo "  -c, --category CATEGORY Search in specific category"
    echo ""
    echo "Examples:"
    echo "  $0 machine learning                    # Search for 'machine learning'"
    echo "  $0 -c computer-science neural          # Search 'neural' in computer science"
    echo "  $0 -i                                  # Interactive mode"
    echo "  $0 -l                                  # List all categories"
    echo "  $0 -b                                  # Browse categories interactively"
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

# Function to browse prompts in a specific category
browse_category_prompts() {
    local category_name="$1"
    local category_file="$PROMPTS_DIR/$category_name.md"
    
    if [[ ! -f "$category_file" ]]; then
        print_color "$RED" "Error: Category file not found: $category_file"
        return 1
    fi
    
    # Clear screen and show header
    clear
    print_header
    print_color "$BOLD$CYAN" "📂 Category: $category_name"
    echo ""
    
    # Get all prompts in the category
    local prompts_data=$(grep -n "^### " "$category_file" 2>/dev/null || echo "")
    
    if [[ -z "$prompts_data" ]]; then
        print_color "$YELLOW" "No prompts found in this category."
        echo ""
        print_color "$BLUE" "0 prompts available"
        echo ""
    else
        # Count total prompts
        local total_prompts=$(echo "$prompts_data" | wc -l | tr -d ' ')
        print_color "$GREEN" "Found $total_prompts prompt(s) in $category_name:"
        echo ""
        
        # Process each prompt
        local prompt_count=1
        while IFS= read -r prompt_line; do
            if [[ -n "$prompt_line" ]]; then
                local line_num=$(echo "$prompt_line" | cut -d: -f1)
                local prompt_title=$(echo "$prompt_line" | cut -d: -f2-)
                
                # Extract prompt section
                local next_prompt_line=$((line_num + 100))
                local prompt_section=$(sed -n "${line_num},${next_prompt_line}p" "$category_file")
                
                # Display prompt information
                printf "%2d. %s\n" "$prompt_count" "$prompt_title"
                
                # Show tags if available
                local tags_line=$(echo "$prompt_section" | grep -m 1 "^\*\*Tags:\*\*" || echo "")
                if [[ -n "$tags_line" ]]; then
                    print_color "$YELLOW" "   🏷️  $tags_line"
                fi
                
                # Show description if available
                local desc_line=$(echo "$prompt_section" | grep -m 1 "^\*\*Description:\*\*" || echo "")
                if [[ -n "$desc_line" ]]; then
                    # Remove the **Description:** prefix and show the actual description
                    local description=$(echo "$desc_line" | sed 's/^\*\*Description:\*\* //')
                    print_color "$MAGENTA" "   📝 $description"
                fi
                
                echo ""
                ((prompt_count++))
            fi
        done <<< "$prompts_data"
    fi
    
    # Show navigation options
    print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    print_color "$GREEN" "  1. 🔍 View specific prompt details"
    print_color "$GREEN" "  2. ↩️  Back to List All Categories"
    print_color "$GREEN" "  3. 🏠 Back to Search Menu"
    echo ""
    
    while true; do
        echo -n "Select option (1-3): "
        read -r browse_choice </dev/tty
        
        case $browse_choice in
            1)
                if [[ -n "$prompts_data" ]]; then
                    echo -n "Enter prompt number (1-$total_prompts): "
                    read -r prompt_selection </dev/tty
                    
                    if [[ "$prompt_selection" =~ ^[0-9]+$ ]] && [[ $prompt_selection -ge 1 ]] && [[ $prompt_selection -le $total_prompts ]]; then
                        # Find the selected prompt
                        local selected_line=$(echo "$prompts_data" | sed -n "${prompt_selection}p")
                        local line_num=$(echo "$selected_line" | cut -d: -f1)
                        
                        # Clear and show prompt details
                        clear
                        print_header
                        print_color "$BOLD$CYAN" "📋 Prompt Details:"
                        echo ""
                        
                        # Extract and display full prompt
                        local next_prompt_line=$((line_num + 100))
                        local full_prompt=$(sed -n "${line_num},${next_prompt_line}p" "$category_file")
                        
                        # Display the prompt
                        print_color "$CYAN" "$(echo \"$selected_line\" | cut -d: -f2-)"
                        echo ""
                        
                        # Show tags
                        local tags_line=$(echo "$full_prompt" | grep -m 1 "^\*\*Tags:\*\*" || echo "")
                        if [[ -n "$tags_line" ]]; then
                            print_color "$YELLOW" "$tags_line"
                            echo ""
                        fi
                        
                        # Show description
                        local desc_line=$(echo "$full_prompt" | grep -m 1 "^\*\*Description:\*\*" || echo "")
                        if [[ -n "$desc_line" ]]; then
                            echo "$desc_line"
                            echo ""
                        fi
                        
                        # Show prompt content
                        local prompt_content=$(echo "$full_prompt" | sed -n '/```/,/```/p' | sed '1d' | sed '$d')
                        if [[ -n "$prompt_content" ]]; then
                            print_color "$MAGENTA" "**Prompt:**"
                            echo ""
                            echo "$prompt_content"
                            echo ""
                        fi
                        
                        print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                        echo ""
                        print_color "$BLUE" "Press Enter to return to category view..."
                        read -r </dev/tty
                        
                        # Return to category view
                        browse_category_prompts "$category_name"
                        return
                    else
                        print_color "$RED" "Invalid prompt number. Please try again."
                    fi
                else
                    print_color "$YELLOW" "No prompts available to view."
                fi
                ;;
            2)
                # Back to list all categories
                return 0
                ;;
            3)
                # Back to search menu
                return 1
                ;;
            *)
                print_color "$RED" "Invalid choice. Please select 1-3."
                ;;
        esac
    done
}

# Function to show interactive category browser
show_category_browser() {
    while true; do
        clear
        print_header
        print_color "$BOLD$CYAN" "📂 Available Categories Browser"
        echo ""
        
        if [[ ! -d "$PROMPTS_DIR" ]]; then
            print_color "$RED" "Error: Prompts directory not found at $PROMPTS_DIR"
            return 1
        fi
        
        # List categories with numbers
        local categories=()
        local count=1
        for file in "$PROMPTS_DIR"/*.md; do
            if [[ -f "$file" ]]; then
                local category=$(basename "$file" .md)
                local title=$(head -n 1 "$file" | sed 's/^# //')
                categories+=("$category")
                printf "%2d. %-25s %s\n" "$count" "$category" "($title)"
                ((count++))
            fi
        done
        
        if [[ ${#categories[@]} -eq 0 ]]; then
            print_color "$YELLOW" "No categories found."
            return 1
        fi
        
        echo ""
        print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        print_color "$GREEN" "Select a category to browse prompts, or:"
        print_color "$GREEN" "  0. ↩️  Back to Search Menu"
        echo ""
        
        echo -n "Enter category number (1-${#categories[@]}) or 0 to return: "
        read -r category_choice </dev/tty
        
        case $category_choice in
            0)
                return 1
                ;;
            [1-9]|[1-9][0-9])
                if [[ $category_choice -ge 1 ]] && [[ $category_choice -le ${#categories[@]} ]]; then
                    local selected_category="${categories[$((category_choice-1))]}"
                    browse_category_prompts "$selected_category"
                    
                    # Check return value to determine next action
                    if [[ $? -eq 1 ]]; then
                        # User chose to go back to search menu
                        return 1
                    fi
                    # Otherwise, continue browsing categories
                else
                    print_color "$RED" "Invalid category number. Please try again."
                    sleep 1
                fi
                ;;
            *)
                print_color "$RED" "Invalid choice. Please enter a number."
                sleep 1
                ;;
        esac
    done
}

# Function to search in a file
search_in_file() {
    local file="$1"
    local search_terms=("${@:2}")
    local found_results=0
    
    # Check if file exists and is readable
    if [[ ! -f "$file" ]] || [[ ! -r "$file" ]]; then
        return 0
    fi
    
    # Search for prompts (lines starting with ###)
    local prompt_lines_raw=$(grep -n "^### [0-9]" "$file" 2>/dev/null || true)
    
    if [[ -z "$prompt_lines_raw" ]]; then
        return 0
    fi
    
    # Check each prompt
    while IFS= read -r prompt_line; do
        local line_num=$(echo "$prompt_line" | cut -d: -f1)
        local prompt_title=$(echo "$prompt_line" | cut -d: -f2-)
        
        # Look ahead 100 lines for content (prompts can be longer and in code blocks)
        local next_prompt_line=$((line_num + 100))
        local prompt_section=$(sed -n "${line_num},${next_prompt_line}p" "$file")
        
        # Check if any search term matches in this section
        local matches=false
        for term in "${search_terms[@]}"; do
            if echo "$prompt_section" | grep -qi "$term"; then
                matches=true
                break
                fi
            done
        
        if [[ "$matches" == "true" ]]; then
            ((found_results++))
            
            # Add this result to global arrays
            add_search_results "$prompt_title" "$file" "$line_num"
        fi
    done <<< "$prompt_lines_raw"
}

# Function to display search results summary
display_search_summary() {
    local total_results=$1
    
    if [[ $total_results -eq 0 ]]; then
        print_color "$YELLOW" "No results found"
        return
    fi
    
    print_color "$GREEN" "Found $total_results result(s):"
                echo ""
    
    # Display detailed information for each result
    for i in "${!SEARCH_RESULTS_TITLES[@]}"; do
        local category=$(basename "${SEARCH_RESULTS_FILES[$i]}" .md)
        local title="${SEARCH_RESULTS_TITLES[$i]}"
        local file="${SEARCH_RESULTS_FILES[$i]}"
        local line_num="${SEARCH_RESULTS_LINES[$i]}"
        
        # Get additional details for this prompt
        local next_prompt_line=$((line_num + 100))
        local prompt_section=$(sed -n "${line_num},${next_prompt_line}p" "$file")
        
        # Display result number and title
        printf "%2d. %s\n" "$((i + 1))" "$title"
        print_color "$CYAN" "   📁 Category: $category"
        
        # Show tags if available
        local tags_line=$(echo "$prompt_section" | grep -m 1 "^\*\*Tags:\*\*" || echo "")
        if [[ -n "$tags_line" ]]; then
            print_color "$YELLOW" "   🏷️  $tags_line"
        fi
        
        # Show description if available
        local desc_line=$(echo "$prompt_section" | grep -m 1 "^\*\*Description:\*\*" || echo "")
        if [[ -n "$desc_line" ]]; then
            # Remove the **Description:** prefix and show the actual description
            local description=$(echo "$desc_line" | sed 's/^\*\*Description:\*\* //')
            print_color "$MAGENTA" "   📝 $description"
            fi
            
            echo ""
    done
    
    # Ask user to select one for details
    echo "----------------------------------------"
    print_color "$BLUE" "Enter a number (1-$total_results) to view full prompt, or press Enter to skip: "
    print_color "$CYAN" "Type 'm' to go back to search options menu"
    echo ""
}

# Function to show prompt details
show_prompt_details() {
    local selection=$1
    
    if [[ ! "$selection" =~ ^[0-9]+$ ]] || [[ $selection -lt 1 ]] || [[ $selection -gt ${#SEARCH_RESULTS_TITLES[@]} ]]; then
        print_color "$RED" "Invalid selection. Please enter a number between 1 and ${#SEARCH_RESULTS_TITLES[@]}"
        return 0 # Indicate failure
    fi
    
    local index=$((selection - 1))
    local file="${SEARCH_RESULTS_FILES[$index]}"
    local line_num="${SEARCH_RESULTS_LINES[$index]}"
    local title="${SEARCH_RESULTS_TITLES[$index]}"
    
    echo ""
    print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color "$BOLD$GREEN" "📋 Prompt Details:"
    echo ""
    
    # Display the full prompt details
    print_color "$CYAN" "$title"
    echo ""
    
    # Look ahead 100 lines for content
    local next_prompt_line=$((line_num + 100))
    local prompt_section=$(sed -n "${line_num},${next_prompt_line}p" "$file")
    
    # Show tags if available
    local tags_line=$(echo "$prompt_section" | grep -m 1 "^\*\*Tags:\*\*" || echo "")
    if [[ -n "$tags_line" ]]; then
        print_color "$YELLOW" "$tags_line"
        echo ""
    fi
    
    # Show description if available
    local desc_line=$(echo "$prompt_section" | grep -m 1 "^\*\*Description:\*\*" || echo "")
    if [[ -n "$desc_line" ]]; then
        echo "$desc_line"
        echo ""
    fi
    
    # Show the full prompt content
    local prompt_content=$(echo "$prompt_section" | sed -n '/```/,/```/p' | sed '1d' | sed '$d')
    if [[ -n "$prompt_content" ]]; then
        print_color "$MAGENTA" "**Prompt:**"
        echo ""
        echo "$prompt_content"
        echo ""
    fi
    
    print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Show action menu
    show_prompt_action_menu "$prompt_content"
    return 0 # Indicate success
}

# Function to show prompt action menu
show_prompt_action_menu() {
    local prompt_content="$1"
    
    while true; do
        echo ""
        print_color "$BOLD$CYAN" "📋 What would you like to do with this prompt?"
        echo ""
        print_color "$GREEN" "  1. 📋 Copy prompt to clipboard"
        print_color "$GREEN" "  2. 🌍 Copy specific language version"
        print_color "$GREEN" "  3. ↩️  Back to search results"
        echo ""
        print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        
        echo -n "Select option (1-3): "
        read -r action_choice </dev/tty
        
        case $action_choice in
            1)
                copy_prompt_to_clipboard "$prompt_content"
                ;;
            2)
                copy_language_version "$prompt_content"
                ;;
            3)
                print_color "$BLUE" "Returning to search results..."
                return 0
                ;;
            *)
                print_color "$RED" "Invalid choice. Please select 1-3."
                ;;
        esac
    done
}

# Function to copy prompt to clipboard
copy_prompt_to_clipboard() {
    local prompt_content="$1"
    
    # Check for clipboard command
    local clipboard_cmd=""
    if command -v pbcopy >/dev/null 2>&1; then
        clipboard_cmd="pbcopy"  # macOS
    elif command -v xclip >/dev/null 2>&1; then
        clipboard_cmd="xclip -selection clipboard"  # Linux with xclip
    elif command -v xsel >/dev/null 2>&1; then
        clipboard_cmd="xsel --clipboard --input"  # Linux with xsel
    elif command -v clip.exe >/dev/null 2>&1; then
        clipboard_cmd="clip.exe"  # Windows with clip.exe
    fi
    
    if [[ -z "$clipboard_cmd" ]]; then
        print_color "$RED" "❌ Clipboard command not found. Please install one of:"
        echo "  - macOS: pbcopy (built-in)"
        echo "  - Linux: xclip or xsel"
        echo "  - Windows: clip.exe (built-in)"
        echo ""
        print_color "$YELLOW" "Prompt content (copy manually):"
        echo "----------------------------------------"
        echo "$prompt_content"
        echo "----------------------------------------"
        return
    fi
    
    # Copy to clipboard
    echo "$prompt_content" | eval "$clipboard_cmd"
    if [[ $? -eq 0 ]]; then
        print_color "$GREEN" "✅ Prompt copied to clipboard successfully!"
    else
        print_color "$RED" "❌ Failed to copy to clipboard"
        echo ""
        print_color "$YELLOW" "Prompt content (copy manually):"
        echo "----------------------------------------"
        echo "$prompt_content"
        echo "----------------------------------------"
    fi
}

# Function to copy specific language version
copy_language_version() {
    local prompt_content="$1"
    
    echo ""
    print_color "$BOLD$CYAN" "🌍 Select Language Version:"
    echo ""
    print_color "$GREEN" "  1. 🇺🇸 English (EN)"
    print_color "$GREEN" "  2. 🇯🇵 Japanese (JP)"
    print_color "$GREEN" "  3. 🇨🇳 Chinese (ZH)"
    print_color "$GREEN" "  4. 🇩🇪 German (DE)"
    print_color "$GREEN" "  5. 🇫🇷 French (FR)"
    print_color "$GREEN" "  6. 🇪🇸 Spanish (ES)"
    print_color "$GREEN" "  7. 🇮🇹 Italian (IT)"
    print_color "$GREEN" "  8. 🇵🇹 Portuguese (PT)"
    print_color "$GREEN" "  9. 🇷🇺 Russian (RU)"
    print_color "$GREEN" "  10. 🇸🇦 Arabic (AR)"
    print_color "$GREEN" "  11. 🇰🇷 Korean (KO)"
    print_color "$GREEN" "  12. 🇮🇳 Hindi (HI)"
    print_color "$GREEN" "  13. ↩️  Back to prompt actions"
    echo ""
    
    echo -n "Select language (1-13): "
    read -r lang_choice </dev/tty
    
    case $lang_choice in
        1) copy_language_prompt "$prompt_content" "EN" ;;
        2) copy_language_prompt "$prompt_content" "JP" ;;
        3) copy_language_prompt "$prompt_content" "ZH" ;;
        4) copy_language_prompt "$prompt_content" "DE" ;;
        5) copy_language_prompt "$prompt_content" "FR" ;;
        6) copy_language_prompt "$prompt_content" "ES" ;;
        7) copy_language_prompt "$prompt_content" "IT" ;;
        8) copy_language_prompt "$prompt_content" "PT" ;;
        9) copy_language_prompt "$prompt_content" "RU" ;;
        10) copy_language_prompt "$prompt_content" "AR" ;;
        11) copy_language_prompt "$prompt_content" "KO" ;;
        12) copy_language_prompt "$prompt_content" "HI" ;;
        13|*) 
            print_color "$BLUE" "Returning to prompt actions..."
            show_prompt_action_menu "$prompt_content"
            return
            ;;
    esac
}

# Function to copy prompt in specific language
copy_language_prompt() {
    local prompt_content="$1"
    local language="$2"
    
    print_color "$BLUE" "🌍 Looking for $language version of this prompt..."
    
    # Get the current prompt number and category from the search results
    local current_prompt_number=""
    local current_category=""
    
    # Extract prompt number from the current search result
    if [[ -n "${SEARCH_RESULTS_TITLES[0]}" ]]; then
        local title="${SEARCH_RESULTS_TITLES[0]}"
        if [[ "$title" =~ ^###\ ([0-9]+)\. ]]; then
            current_prompt_number="${BASH_REMATCH[1]}"
        fi
        
        # Get category from the file path
        local file="${SEARCH_RESULTS_FILES[0]}"
        current_category=$(basename "$file" .md)
    fi
    
    if [[ -z "$current_prompt_number" ]] || [[ -z "$current_category" ]]; then
        print_color "$RED" "❌ Could not determine prompt number or category. Copying English version instead."
        copy_prompt_to_clipboard "$prompt_content"
        return
    fi
    
    # Check if the language folder exists
    local language_dir="$SCRIPT_DIR/Prompts/$language"
    if [[ ! -d "$language_dir" ]]; then
        print_color "$YELLOW" "⚠️  Language folder for $language not found at $language_dir"
        print_color "$CYAN" "Copying English version instead."
        copy_prompt_to_clipboard "$prompt_content"
        return
    fi
    
    # Check if the category file exists in the language folder
    local language_category_file="$language_dir/$current_category.md"
    if [[ ! -f "$language_category_file" ]]; then
        print_color "$YELLOW" "⚠️  Category file for $language not found: $language_category_file"
        print_color "$CYAN" "Copying English version instead."
        copy_prompt_to_clipboard "$prompt_content"
        return
    fi
    
    # Search for the prompt in the language file
    local prompt_line=$(grep -n "^### $current_prompt_number\." "$language_category_file" 2>/dev/null || true)
    
    if [[ -z "$prompt_line" ]]; then
        print_color "$YELLOW" "⚠️  Prompt $current_prompt_number not found in $language version of $current_category"
        print_color "$CYAN" "Copying English version instead."
        copy_prompt_to_clipboard "$prompt_content"
        return
    fi
    
    # Extract the prompt content from the language file
    local line_num=$(echo "$prompt_line" | cut -d: -f1)
    local next_prompt_line=$((line_num + 100))
    local prompt_section=$(sed -n "${line_num},${next_prompt_line}p" "$language_category_file")
    
    # Extract the prompt content (between ``` blocks)
    local translated_prompt=$(echo "$prompt_section" | sed -n '/```/,/```/p' | sed '1d' | sed '$d')
    
    if [[ -z "$translated_prompt" ]]; then
        print_color "$YELLOW" "⚠️  Could not extract prompt content from $language version"
        print_color "$CYAN" "Copying English version instead."
        copy_prompt_to_clipboard "$prompt_content"
        return
    fi
    
    # Copy the translated prompt to clipboard
    print_color "$GREEN" "✅ Found $language version of prompt $current_prompt_number in $current_category"
    copy_prompt_to_clipboard "$translated_prompt"
}

# Function for interactive search
interactive_search() {
    print_color "$BLUE" "🔍 Interactive Prompt Search"
    echo ""
    print_color "$CYAN" "Type 'quit' or 'q' to exit, 'help' for tips"
    echo ""
    
    while true; do
        echo -n "Enter search keywords: "
        read -r keywords </dev/tty
        
        if [[ "$keywords" == "quit" ]] || [[ "$keywords" == "q" ]]; then
            print_color "$GREEN" "Goodbye!"
            break
        fi
        
        if [[ "$keywords" == "help" ]]; then
            print_color "$YELLOW" "Search Tips:"
            print_color "$CYAN" "  • Use multiple words: 'machine learning neural'"
            print_color "$CYAN" "  • Be specific: 'data analysis' instead of just 'data'"
            print_color "$CYAN" "  • Try different terms: 'AI' or 'artificial intelligence'"
            echo ""
            continue
        fi
        
        if [[ -z "$keywords" ]]; then
            print_color "$YELLOW" "Please enter some keywords to search."
            continue
        fi
        
        echo ""
        print_color "$BLUE" "🔍 Searching for: '$keywords'"
        echo ""
        
        # Convert keywords to array
        read -ra search_terms <<< "$keywords"
        
        # Perform search
        clear_search_results
        for file in "$PROMPTS_DIR"/*.md; do
            if [[ -f "$file" ]]; then
                search_in_file "$file" "${search_terms[@]}"
            fi
        done
        
        local total_results=$SEARCH_RESULTS_COUNT
        
        display_search_summary "$total_results"
        
        read -r selection </dev/tty
        
        if [[ -z "$selection" ]]; then
            print_color "$YELLOW" "Skipping prompt details."
        elif [[ "$selection" == "m" ]] || [[ "$selection" == "M" ]]; then
            print_color "$BLUE" "Returning to search options menu..."
            return 0
        elif [[ "$selection" =~ ^[0-9]+$ ]] && [[ $selection -ge 1 ]] && [[ $selection -le $total_results ]]; then
            show_prompt_details "$selection"
            # If user chose to go back to search results, redisplay them
            if [[ $? -eq 0 ]]; then
                echo ""
                display_search_summary "$total_results"
                read -r selection2 </dev/tty
                
                if [[ -z "$selection2" ]]; then
                    print_color "$YELLOW" "Skipping prompt details."
                elif [[ "$selection2" == "m" ]] || [[ "$selection2" == "M" ]]; then
                    print_color "$BLUE" "Returning to search options menu..."
                    return 0
                elif [[ "$selection2" =~ ^[0-9]+$ ]] && [[ $selection2 -ge 1 ]] && [[ $selection2 -le $total_results ]]; then
                    show_prompt_details "$selection2"
                else
                    print_color "$RED" "Invalid selection. Skipping prompt details."
                fi
            fi
        else
            print_color "$RED" "Invalid selection. Skipping prompt details."
        fi
        
        echo ""
    done
}

# Function to show search options menu
show_search_options_menu() {
    while true; do
        print_header
        local interface_lang=$(read_profile_value "INTERFACE_LANGUAGE" "EN")
        
        print_color "$BOLD$CYAN" "$(get_string "SEARCH_MENU_TITLE" "$interface_lang")"
        echo ""
        print_color "$GREEN" "🔍 Simple Search Options:"
        echo ""
        print_color "$YELLOW" "  1. Interactive Search (recommended)"
        print_color "$YELLOW" "  2. Quick Keyword Search"
        print_color "$YELLOW" "  3. Browse All Categories"
        print_color "$YELLOW" "  4. Back to Main Menu"
        echo ""
        print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        
        echo -n "Select option (1-4): "
        read -r search_choice </dev/tty
        
        case $search_choice in
            1)
                print_color "$BLUE" "🚀 Launching Interactive Search..."
                echo ""
                interactive_search
                ;;
            2)
                echo ""
                echo -n "Enter keywords to search: "
                read -r keywords </dev/tty
                if [[ -n "$keywords" ]]; then
                    echo ""
                    print_color "$BLUE" "🔍 Searching for: $keywords"
                    echo ""
                    perform_search "$keywords"
                fi
                ;;
            3)
                echo ""
                print_color "$BLUE" "📂 Launching Category Browser..."
                show_category_browser
                
                # Check if user wants to return to search menu
                if [[ $? -eq 1 ]]; then
                    # User chose to go back to search menu, continue loop
                    continue
                fi
                ;;
            4|*)
                print_color "$BLUE" "Returning to main menu..."
                exit 0
                ;;
        esac
    done
}

# Function to perform search
perform_search() {
    local keywords="$1"
    local search_terms=("$@")
    
    # Search in all Prompts/EN files where the actual prompts are
    clear_search_results
    for file in "$PROMPTS_DIR"/*.md; do
        if [[ -f "$file" ]]; then
            search_in_file "$file" "${search_terms[@]}"
        fi
    done
    
    local total_results=$SEARCH_RESULTS_COUNT
    
    if [[ $total_results -eq 0 ]]; then
        print_color "$YELLOW" "No results found for '$keywords'"
        print_color "$CYAN" "Try different keywords or be more specific"
        echo ""
        print_color "$BLUE" "Press Enter to return to search menu..."
        read -r input </dev/tty
        return
    fi
    
    display_search_summary "$total_results"
    
    read -r selection </dev/tty
    
    if [[ -z "$selection" ]]; then
        print_color "$YELLOW" "Skipping prompt details."
    elif [[ "$selection" == "m" ]] || [[ "$selection" == "M" ]]; then
        print_color "$BLUE" "Returning to search options menu..."
        return
    elif [[ "$selection" =~ ^[0-9]+$ ]] && [[ $selection -ge 1 ]] && [[ $selection -le $total_results ]]; then
        show_prompt_details "$selection"
        # If user chose to go back to search results, redisplay them
        if [[ $? -eq 0 ]]; then
            echo ""
            display_search_summary "$total_results"
            read -r selection2 </dev/tty
            
            if [[ -z "$selection2" ]]; then
                print_color "$YELLOW" "Skipping prompt details."
            elif [[ "$selection2" == "m" ]] || [[ "$selection2" == "M" ]]; then
                print_color "$BLUE" "Returning to search options menu..."
                return
            elif [[ "$selection2" =~ ^[0-9]+$ ]] && [[ $selection2 -ge 1 ]] && [[ $selection2 -le $total_results ]]; then
                show_prompt_details "$selection2"
            else
                print_color "$RED" "Invalid selection. Skipping prompt details."
            fi
        fi
    else
        print_color "$RED" "Invalid selection. Skipping prompt details."
    fi
}

# Function to print header
print_header() {
    clear
    print_color "$BOLD$BLUE" "╔══════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$BLUE" "║                                                              ║"
    print_color "$BOLD$BLUE" "║           🎓 AWESOME ACADEMIC PROMPTS TOOLKIT 🎓            ║"
    print_color "$BOLD$BLUE" "║                                                              ║"
    print_color "$BOLD$BLUE" "║        Your Complete Academic AI Prompt Management          ║"
    print_color "$BOLD$BLUE" "║                     Command Center                           ║"
    print_color "$BOLD$BLUE" "║                                                              ║"
    print_color "$BOLD$BLUE" "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Main function
main() {
    # Default options
    local INTERACTIVE=false
    local LIST_CATEGORIES=false
    local BROWSE_CATEGORIES=false
    local CATEGORY=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -i|--interactive)
                INTERACTIVE=true
                shift
                ;;
            -l|--list-categories)
                LIST_CATEGORIES=true
                shift
                ;;
            -b|--browse-categories)
                BROWSE_CATEGORIES=true
                shift
                ;;
            -c|--category)
                CATEGORY="$2"
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
        print_color "$YELLOW" "Make sure you're running this from the correct directory"
        exit 1
    fi
    
    # Handle special modes
    if [[ "$LIST_CATEGORIES" == "true" ]]; then
        list_categories
        exit 0
    fi
    
    if [[ "$BROWSE_CATEGORIES" == "true" ]]; then
        show_category_browser
        exit 0
    fi
    
    if [[ "$INTERACTIVE" == "true" ]]; then
        interactive_search
        exit 0
    fi
    
    # Handle category-specific search
    if [[ -n "$CATEGORY" ]]; then
        local category_file="$PROMPTS_DIR/$CATEGORY.md"
        if [[ ! -f "$category_file" ]]; then
            print_color "$RED" "Error: Category file not found: $category_file"
            print_color "$YELLOW" "Use -l to list available categories"
            exit 1
        fi
        
        if [[ $# -eq 0 ]]; then
            print_color "$YELLOW" "No search terms provided for category search"
            print_color "$CYAN" "Usage: $0 -c $CATEGORY <keywords>"
            exit 1
        fi
        
        local search_terms=("$@")
        print_color "$BLUE" "🔍 Searching in category '$CATEGORY' for: $(IFS=' '; echo "${search_terms[*]}")"
        echo ""
        
        clear_search_results
        search_in_file "$category_file" "${search_terms[@]}"
        local total_results=$SEARCH_RESULTS_COUNT
        
        if [[ $total_results -eq 0 ]]; then
            print_color "$YELLOW" "No results found in category '$CATEGORY'"
        exit 0
    fi
    
        display_search_summary "$total_results"
        
        read -r selection </dev/tty
        
        if [[ -z "$selection" ]]; then
            print_color "$YELLOW" "Skipping prompt details."
        elif [[ "$selection" == "m" ]] || [[ "$selection" == "M" ]]; then
            print_color "$BLUE" "Returning to search options menu..."
            show_search_options_menu
        elif [[ "$selection" =~ ^[0-9]+$ ]] && [[ $selection -ge 1 ]] && [[ $selection -le $total_results ]]; then
            show_prompt_details "$selection"
        else
            print_color "$RED" "Invalid selection. Skipping prompt details."
        fi
        return 0
    fi
    
    # Regular keyword search
    if [[ $# -eq 0 ]]; then
        # Show search options menu when no arguments provided
        show_search_options_menu
        exit 0
    fi
    
    local search_terms=("$@")
    perform_search "${search_terms[@]}"
}

# Run main function
main "$@"