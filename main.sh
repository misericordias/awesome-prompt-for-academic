#!/opt/homebrew/bin/bash

# Main Menu Script for Awesome Academic Prompts
# Entry point for all available CLI tools

set -euo pipefail

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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
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

# Function to show main menu
show_main_menu() {
    print_color "$CYAN" "📋 Available Tools:"
    echo ""
    print_color "$GREEN" "  1. 📝 Add New Prompt"
    print_color "$YELLOW" "     └─ Interactive tool to add academic prompts with validation"
    echo ""
    print_color "$GREEN" "  2. 🔍 Search Prompts"
    print_color "$YELLOW" "     └─ Find prompts by keywords, categories, or tags"
    echo ""
    print_color "$GREEN" "  3. 🏷️  Manage Categories"
    print_color "$YELLOW" "     └─ Add/manage Research Areas and Prompt Categories"
    echo ""
    print_color "$GREEN" "  4. 📊 Repository Statistics"
    print_color "$YELLOW" "     └─ View collection statistics and overview"
    echo ""
    print_color "$GREEN" "  5. 🌍 Translation Tools"
    print_color "$YELLOW" "     └─ Manage multilingual translations and consistency"
    echo ""
    print_color "$GREEN" "  6. 📚 Documentation"
    print_color "$YELLOW" "     └─ Access help and documentation"
    echo ""
    print_color "$GREEN" "  7. 🚪 Exit"
    print_color "$YELLOW" "  q. 🚪 Quick Exit (or just press Enter)"
    echo ""
    print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Function to show statistics
show_statistics() {
    # Save current shell options
    local old_opts=$(set +o)
    
    # Disable strict error handling for this function
    set +euo pipefail
    
    print_header
    print_color "$BOLD$CYAN" "📊 Repository Statistics"
    echo ""
    
    local prompts_dir="$SCRIPT_DIR/Prompts/EN"
    
    if [[ ! -d "$prompts_dir" ]]; then
        print_color "$RED" "❌ Prompts directory not found at: $prompts_dir"
        print_color "$BLUE" "Press Enter or type 'q' to return to main menu..."
        read -r input </dev/tty
        if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
            return
        fi
        return
    fi
    
    local total_files=0
    local total_prompts=0
    local total_research_areas=0
    local total_prompt_categories=0
    
    print_color "$BLUE" "📂 Categories Overview:"
    echo ""
    
    for file in "$prompts_dir"/*.md; do
        [[ -f "$file" ]] || continue
        
        ((total_files++))
        local category=$(basename "$file" .md)
        local title=$(head -n 1 "$file" | sed 's/^# //')
        
        # Count prompts
        local prompt_count=0
        if grep -q "^### [0-9]" "$file" 2>/dev/null; then
            prompt_count=$(grep -c "^### [0-9]" "$file" 2>/dev/null)
        fi
        
        # Count research areas
        local research_count=0
        if sed -n '/## Research Areas/,/^## /p' "$file" | grep -q '^- ' 2>/dev/null; then
            research_count=$(sed -n '/## Research Areas/,/^## /p' "$file" | grep -c '^- ' 2>/dev/null)
        fi
        
        # Count prompt categories
        local category_count=0
        if sed -n '/## Prompt Categories/,/^## /p' "$file" | grep -q '^- ' 2>/dev/null; then
            category_count=$(sed -n '/## Prompt Categories/,/^## /p' "$file" | grep -c '^- ' 2>/dev/null)
        fi
        
        total_prompts=$((total_prompts + prompt_count))
        total_research_areas=$((total_research_areas + research_count))
        total_prompt_categories=$((total_prompt_categories + category_count))
        
        printf "  %-25s %s\n" "$category" "($prompt_count prompts)"
        print_color "$YELLOW" "    └─ $title"
        echo ""
    done
    
    if [[ $total_files -eq 0 ]]; then
        print_color "$YELLOW" "No category files found in $prompts_dir"
        print_color "$BLUE" "Press Enter or type 'q' to return to main menu..."
        read -r input </dev/tty
        if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
            return
        fi
        return
    fi
    
    print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    print_color "$BOLD$GREEN" "📈 Summary:"
    echo ""
    print_color "$CYAN" "  📁 Categories:        $total_files"
    print_color "$CYAN" "  📝 Total Prompts:     $total_prompts"
    print_color "$CYAN" "  🔬 Research Areas:    $total_research_areas"
    print_color "$CYAN" "  📋 Prompt Categories: $total_prompt_categories"
    echo ""
    
    # Restore original shell options
    eval "$old_opts"
    
    # Add return to main menu option
    print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    print_color "$GREEN" "  1. 🔙 Return to Main Menu"
    print_color "$GREEN" "  2. 📊 View Statistics Again"
    print_color "$YELLOW" "  q. 🔙 Quick Return (or just press Enter)"
    echo ""
    
    while true; do
        echo -n "Select option (1-2) or type 'q' to return: "
        read -r stat_choice </dev/tty
        
        case $stat_choice in
            1|q|Q|"")
                break
                ;;
            2)
                show_statistics
                return
                ;;
            *)
                print_color "$RED" "Invalid choice. Please select 1-2 or type 'q' to return."
                sleep 1
                ;;
        esac
    done
}

# Function to show documentation menu
show_documentation_menu() {
    while true; do
        print_header
        print_color "$BOLD$CYAN" "📚 Documentation & Help"
        echo ""
        print_color "$GREEN" "  1. 📖 View README.md"
        print_color "$GREEN" "  2. 📝 Add Prompt Tool Guide (CLI_README.md)"
        print_color "$GREEN" "  3. 🏷️  Category Management Guide (MANAGE_CATEGORIES_README.md)"
        print_color "$GREEN" "  4. 📋 Prompt Format Guidelines (PROMPT_FORMAT.md)"
        print_color "$GREEN" "  5. 🔍 Search Tool Guide (SEARCH_README.md)"
        print_color "$GREEN" "  6. 🔧 Tool Help Commands"
        print_color "$GREEN" "  7. 🔙 Back to Main Menu"
        print_color "$YELLOW" "  q. 🔙 Quick Return (or just press Enter)"
        echo ""
        print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        
        echo -n "Select option (1-7) or type 'q' to return: "
        read -r choice </dev/tty
        
        case $choice in
            1)
                if [[ -f "$SCRIPT_DIR/README.md" ]]; then
                    less "$SCRIPT_DIR/README.md"
                    print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                else
                    print_color "$RED" "README.md not found!"
                    print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                fi
                ;;
            2)
                if [[ -f "$SCRIPT_DIR/CLI_README.md" ]]; then
                    less "$SCRIPT_DIR/CLI_README.md"
                    print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                else
                    print_color "$RED" "CLI_README.md not found! (Documentation is now integrated in README.md)"
                    print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                fi
                ;;
            3)
                if [[ -f "$SCRIPT_DIR/MANAGE_CATEGORIES_README.md" ]]; then
                    less "$SCRIPT_DIR/MANAGE_CATEGORIES_README.md"
                    print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                else
                    print_color "$RED" "MANAGE_CATEGORIES_README.md not found! (Documentation is now integrated in README.md)"
                    print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                fi
                ;;
            4)
                if [[ -f "$SCRIPT_DIR/PROMPT_FORMAT.md" ]]; then
                    less "$SCRIPT_DIR/PROMPT_FORMAT.md"
                    print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                else
                    print_color "$RED" "PROMPT_FORMAT.md not found! (Documentation is now integrated in README.md)"
                    print_color "$BLUE" "Press Enter to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                fi
                ;;
            5)
                if [[ -f "$SCRIPT_DIR/SEARCH_README.md" ]]; then
                    less "$SCRIPT_DIR/README.md"
                    print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                else
                    print_color "$RED" "SEARCH_README.md not found! (Documentation is now integrated in README.md)"
                    print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                    read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                fi
                ;;
            6)
                print_header
                print_color "$BOLD$CYAN" "🔧 Tool Help Commands"
                echo ""
                print_color "$GREEN" "Add Prompt Tool:"
                print_color "$YELLOW" "  ./scripts/add_prompt.sh --help"
                echo ""
                print_color "$GREEN" "Search Tool:"
                print_color "$YELLOW" "  ./scripts/search_prompts.sh --help"
                echo ""
                print_color "$GREEN" "Category Management:"
                print_color "$YELLOW" "  ./scripts/manage_categories.sh --help"
                echo ""
                print_color "$GREEN" "Translation Tools:"
                print_color "$YELLOW" "  ./scripts/translate_prompts.sh --help"
                echo ""
                print_color "$BLUE" "Press Enter or type 'q' to return to documentation menu..."
                read -r input </dev/tty
                    if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                        break
                    fi
                ;;
            7|q|Q|"")
                break
                ;;
            *)
                print_color "$RED" "Invalid choice. Please select 1-7 or type 'q' to return."
                sleep 1
                ;;
        esac
    done
}

# Function to show translation menu
show_translation_menu() {
    while true; do
        print_header
        print_color "$BOLD$CYAN" "🌍 Translation Tools & Multilingual Management"
        echo ""
        print_color "$GREEN" "  1. 📊 Translation Status"
        print_color "$YELLOW" "     └─ View translation status across all 12 languages"
        echo ""
        print_color "$GREEN" "  2. 🔍 Verify Consistency"
        print_color "$YELLOW" "     └─ Check file consistency across all languages"
        echo ""
        print_color "$GREEN" "  3. 📈 Count Prompts"
        print_color "$YELLOW" "     └─ Count prompts in each language"
        echo ""
        print_color "$GREEN" "  4. 🌐 Language Overview"
        print_color "$YELLOW" "     └─ Show supported languages and statistics"
        echo ""
        print_color "$GREEN" "  5. 🔙 Back to Main Menu"
        print_color "$YELLOW" "  q. 🔙 Quick Return (or just press Enter)"
        echo ""
        print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        
        echo -n "Select option (1-5) or type 'q' to return: "
        read -r choice </dev/tty
        
        case $choice in
            1)
                print_header
                "$SCRIPT_DIR/scripts/translate_prompts.sh" -s
                echo ""
                print_color "$BLUE" "Press Enter or type 'q' to return to translation menu..."
                read -r input </dev/tty
                if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                    break
                fi
                ;;
            2)
                print_header
                "$SCRIPT_DIR/scripts/translate_prompts.sh" -v
                echo ""
                print_color "$BLUE" "Press Enter or type 'q' to return to translation menu..."
                read -r input </dev/tty
                if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                    break
                fi
                ;;
            3)
                print_header
                "$SCRIPT_DIR/scripts/translate_prompts.sh" -c
                echo ""
                print_color "$BLUE" "Press Enter or type 'q' to return to translation menu..."
                read -r input </dev/tty
                if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                    break
                fi
                ;;
            4)
                print_header
                print_color "$BOLD$CYAN" "🌐 Supported Languages Overview"
                echo ""
                print_color "$BLUE" "The repository supports 12 major academic languages:"
                echo ""
                print_color "$GREEN" "🇺🇸 EN - English      🇯🇵 JP - Japanese    🇨🇳 ZH - Chinese"
                print_color "$GREEN" "  DE - German       🇫🇷 FR - French      🇪🇸 ES - Spanish"
                print_color "$GREEN" "🇮🇹 IT - Italian      🇵🇹 PT - Portuguese  🇷🇺 RU - Russian"
                print_color "$GREEN" "🇸🇦 AR - Arabic       🇰🇷 KO - Korean      🇮🇳 HI - Hindi"
                echo ""
                print_color "$YELLOW" "Each language contains 9 category files:"
                print_color "$CYAN" "• business-management.md    • computer-science.md"
                print_color "$CYAN" "• engineering.md           • general.md"
                print_color "$CYAN" "• humanities.md            • mathematics-statistics.md"
                print_color "$CYAN" "• medical-sciences.md      • natural-sciences.md"
                print_color "$CYAN" "• social-sciences.md"
                echo ""
                print_color "$BOLD$GREEN" "Total: 108 category files across 12 languages"
                echo ""
                print_color "$BLUE" "Press Enter or type 'q' to return to translation menu..."
                read -r input </dev/tty
                if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                    break
                fi
                ;;
            5|q|Q|"")
                break
                ;;
            *)
                print_color "$RED" "Invalid choice. Please select 1-5 or type 'q' to return."
                sleep 1
                ;;
        esac
    done
}

# Function to check if scripts exist
check_scripts() {
    local missing_scripts=()
    
    if [[ ! -f "$SCRIPT_DIR/scripts/add_prompt.sh" ]]; then
        missing_scripts+=("scripts/add_prompt.sh")
    fi
    
    if [[ ! -f "$SCRIPT_DIR/scripts/search_prompts.sh" ]]; then
        missing_scripts+=("scripts/search_prompts.sh")
    fi
    
    if [[ ! -f "$SCRIPT_DIR/scripts/manage_categories.sh" ]]; then
        missing_scripts+=("scripts/manage_categories.sh")
    fi
    
    if [[ ! -f "$SCRIPT_DIR/scripts/translate_prompts.sh" ]]; then
        missing_scripts+=("scripts/translate_prompts.sh")
    fi
    
    if [[ ${#missing_scripts[@]} -gt 0 ]]; then
        print_color "$RED" "⚠️  Warning: Missing scripts:"
        for script in "${missing_scripts[@]}"; do
            print_color "$YELLOW" "  - $script"
        done
        echo ""
        print_color "$BLUE" "Some menu options may not work properly."
        echo ""
        print_color "$BLUE" "Press Enter to continue anyway..."
        read -r </dev/tty
    fi
}

# Function to run tool with error handling
run_tool() {
    local tool="$1"
    local tool_name="$2"
    
    if [[ ! -f "$SCRIPT_DIR/$tool" ]]; then
        print_color "$RED" "❌ Error: $tool not found!"
        print_color "$BLUE" "Press Enter to continue..."
        read -r </dev/tty
        return
    fi
    
    if [[ ! -x "$SCRIPT_DIR/$tool" ]]; then
        print_color "$YELLOW" "Making $tool executable..."
        chmod +x "$SCRIPT_DIR/$tool"
    fi
    
    print_color "$BLUE" "🚀 Launching $tool_name..."
    echo ""
    
    # Run the tool and capture exit status
    "$SCRIPT_DIR/$tool"
    local exit_status=$?
    
    # If exit status is 0 (normal completion), show completion message
    # If exit status is non-zero (user cancelled/returned), just return to menu
    if [[ $exit_status -eq 0 ]]; then
        echo ""
        print_color "$GREEN" "✅ $tool_name completed."
        print_color "$BLUE" "Press Enter to return to main menu..."
        read -r </dev/tty
    fi
}

# Main function
main() {
    # Check for required scripts
    check_scripts
    
    while true; do
        print_header
        show_main_menu
        
        echo -n "Select option (1-7) or type 'q' to exit: "
        read -r choice </dev/tty
        
        case $choice in
            1)
                run_tool "scripts/add_prompt.sh" "Add Prompt Tool"
                ;;
            2)
                # Show search submenu
                while true; do
                    print_header
                    print_color "$BOLD$CYAN" "🔍 Search Prompts"
                    echo ""
                    print_color "$GREEN" "  1. 🔍 Interactive Search"
                    print_color "$GREEN" "  2. 📝 Quick Keyword Search"
                    print_color "$GREEN" "  3. 📂 Browse by Category"
                    print_color "$GREEN" "  4. 🏷️  Search by Tag"
                    print_color "$GREEN" "  5. 📋 List All Categories"
                    print_color "$GREEN" "  6. 📋 Copy Prompt to Clipboard"
                    print_color "$GREEN" "  7. 🔙 Back to Main Menu"
                    print_color "$YELLOW" "  q. 🔙 Quick Return (or just press Enter)"
                    echo ""
                    print_color "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    echo ""
                    
                    echo -n "Select search option (1-7) or type 'q' to return: "
                    read -r search_choice </dev/tty
                    
                    case $search_choice in
                        1)
                            print_color "$BLUE" "🚀 Launching Interactive Search..."
                            echo ""
                            "$SCRIPT_DIR/scripts/search_prompts.sh" -i
                            echo ""
                            print_color "$GREEN" "✅ Interactive Search completed."
                            print_color "$BLUE" "Press Enter or type 'q' to return to search menu..."
                            read -r input </dev/tty
                            if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                                break
                            fi
                            ;;
                        2)
                            echo ""
                            echo -n "Enter keywords to search (or 'back' to return): "
                            read -r keywords </dev/tty
                            if [[ "$keywords" == "back" ]]; then
                                continue
                            elif [[ -n "$keywords" ]]; then
                                "$SCRIPT_DIR/scripts/search_prompts.sh" $keywords
                                echo ""
                                print_color "$BLUE" "Press Enter or type 'q' to return to search menu..."
                                read -r input </dev/tty
                                if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                                    break
                                fi
                            fi
                            ;;
                                                3)
                            echo ""
                            echo -n "Enter category name (or 'back' to return): "
                            read -r category </dev/tty
                            if [[ "$category" == "back" ]]; then
                                continue
                            elif [[ -n "$category" ]]; then
                                echo -n "Enter search keywords (optional, or 'back' to return): "
                                read -r keywords </dev/tty
                            if [[ "$keywords" == "back" ]]; then
                                continue
                            elif [[ -n "$keywords" ]]; then
                                "$SCRIPT_DIR/scripts/search_prompts.sh" -c "$category" $keywords
                            else
                                "$SCRIPT_DIR/scripts/search_prompts.sh" -c "$category" ""
                            fi
                            echo ""
                            print_color "$BLUE" "Press Enter or type 'q' to return to search menu..."
                            read -r input </dev/tty
                            if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                                break
                            fi
                            fi
                            ;;
                        4)
                            echo ""
                            echo -n "Enter tag to search (or 'back' to return): "
                            read -r tag </dev/tty
                            if [[ "$tag" == "back" ]]; then
                                continue
                            elif [[ -n "$tag" ]]; then
                                "$SCRIPT_DIR/scripts/search_prompts.sh" -t "$tag"
                                echo ""
                                print_color "$BLUE" "Press Enter or type 'q' to return to search menu..."
                                read -r input </dev/tty
                                if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                                    break
                                fi
                            fi
                            ;;
                        5)
                            "$SCRIPT_DIR/scripts/search_prompts.sh" -l
                            echo ""
                            print_color "$BLUE" "Press Enter or type 'q' to return to search menu..."
                            read -r input </dev/tty
                            if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                                break
                            fi
                            ;;
                        6)
                            echo ""
                            print_color "$BLUE" "📋 Copy Prompt to Clipboard"
                            echo ""
                            echo -n "Enter prompt number to copy (or 'back' to return): "
                            read -r prompt_num </dev/tty
                            if [[ "$prompt_num" == "back" ]]; then
                                continue
                            elif [[ -n "$prompt_num" ]] && [[ "$prompt_num" =~ ^[0-9]+$ ]]; then
                                echo -n "Enter language (EN, ZH, JP, etc.) or press Enter for English: "
                                read -r language </dev/tty
                                if [[ "$language" == "back" ]]; then
                                    continue
                                elif [[ -z "$language" ]]; then
                                    language="EN"
                                fi
                                echo ""
                                print_color "$BLUE" "🚀 Copying prompt $prompt_num to clipboard..."
                                "$SCRIPT_DIR/scripts/search_prompts.sh" --copy "$prompt_num" --lang "$language"
                                echo ""
                                print_color "$BLUE" "Press Enter or type 'q' to return to search menu..."
                                read -r input </dev/tty
                                if [[ "$input" == "q" ]] || [[ "$input" == "Q" ]]; then
                                    break
                                fi
                            else
                                print_color "$RED" "Invalid prompt number. Please enter a valid number."
                                sleep 1
                            fi
                            ;;
                        7|q|Q|"")
                            break
                            ;;
                        *)
                            print_color "$RED" "Invalid choice. Please select 1-7 or type 'q' to return."
                            sleep 1
                            ;;
                    esac
                done
                ;;
            3)
                run_tool "scripts/manage_categories.sh" "Category Management Tool"
                ;;
            4)
                show_statistics
                ;;
            5)
                show_translation_menu
                ;;
            6)
                show_documentation_menu
                ;;
            7|q|Q|"")
                print_color "$GREEN" "👋 Thank you for using Awesome Academic Prompts Toolkit!"
                print_color "$BLUE" "Happy researching! 🎓✨"
                exit 0
                ;;
            *)
                print_color "$RED" "Invalid choice. Please select 1-7 or type 'q' to exit."
                sleep 1
                ;;
        esac
    done
}

# Show welcome message on first run
show_welcome() {
    if [[ "${1:-}" != "--no-welcome" ]]; then
        print_header
        print_color "$YELLOW" "Welcome to the Academic Prompts Toolkit! 🎉"
        echo ""
        print_color "$CYAN" "This toolkit provides comprehensive tools for managing academic AI prompts:"
        print_color "$CYAN" "• Add new prompts with proper formatting and validation"
        print_color "$CYAN" "• Search existing prompts by keywords, categories, or tags"
        print_color "$CYAN" "• Manage research areas and prompt categories"
        print_color "$CYAN" "• View repository statistics and documentation"
        print_color "$CYAN" "• Support for 12 major academic languages (108 total files)"
        echo ""
        print_color "$BLUE" "Press Enter to continue to the main menu..."
        read -r </dev/tty
    fi
}

# Run the application
show_welcome "$@"
main "$@"