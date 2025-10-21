#!/bin/bash
# User prompts - all interactive questions with modern UI

# Interactive menu with arrow keys
# Usage: select_option "Title" "option1" "option2" "option3"
# Returns: selected index (0-based)
select_option() {
    local title="$1"
    shift
    local options=("$@")
    local selected=0
    local key=""
    
    # Hide cursor
    tput civis
    
    while true; do
        # Clear previous menu
        for ((i=0; i<${#options[@]}+2; i++)); do
            tput cuu1 2>/dev/null || true
            tput el
        done
        
        # Display title
        echo -e "${CYAN}${title}${NC}"
        echo ""
        
        # Display options
        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                echo -e "  ${GREEN}❯${NC} ${BOLD}${options[$i]}${NC}"
            else
                echo -e "    ${options[$i]}"
            fi
        done
        
        # Read key from terminal device
        read -rsn1 key </dev/tty
        
        case "$key" in
            $'\x1b')  # ESC sequence
                read -rsn2 key </dev/tty
                case "$key" in
                    '[A')  # Up arrow
                        selected=$((selected - 1))
                        if [ $selected -lt 0 ]; then
                            selected=$((${#options[@]}-1))
                        fi
                        ;;
                    '[B')  # Down arrow
                        selected=$((selected + 1))
                        if [ $selected -ge ${#options[@]} ]; then
                            selected=0
                        fi
                        ;;
                esac
                ;;
            '')  # Enter
                # Show cursor
                tput cnorm
                echo ""
                return $selected
                ;;
        esac
    done
}

# Multi-select menu with arrow keys and space to toggle
# Usage: multi_select "Title" "option1" "option2" "option3"
# Returns: space-separated indices of selected items
multi_select() {
    local title="$1"
    shift
    local options=("$@")
    local selected=0
    local key=""
    local -a checked=()
    
    # Initialize all as unchecked
    for ((i=0; i<${#options[@]}; i++)); do
        checked[$i]=false
    done
    
    # Hide cursor
    tput civis
    
    while true; do
        # Clear previous menu
        for ((i=0; i<${#options[@]}+3; i++)); do
            tput cuu1 2>/dev/null || true
            tput el
        done
        
        # Display title
        echo -e "${CYAN}${title}${NC}"
        echo -e "${DIM}(Use ↑↓ to navigate, Space to select, Enter to confirm)${NC}"
        echo ""
        
        # Display options
        for i in "${!options[@]}"; do
            local checkbox="[ ]"
            if [ "${checked[$i]}" = true ]; then
                checkbox="[${GREEN}✓${NC}]"
            fi
            
            if [ $i -eq $selected ]; then
                echo -e "  ${GREEN}❯${NC} ${checkbox} ${BOLD}${options[$i]}${NC}"
            else
                echo -e "    ${checkbox} ${options[$i]}"
            fi
        done
        
        # Read key from terminal device
        read -rsn1 key </dev/tty
        
        case "$key" in
            $'\x1b')  # ESC sequence
                read -rsn2 key </dev/tty
                case "$key" in
                    '[A')  # Up arrow
                        selected=$((selected - 1))
                        if [ $selected -lt 0 ]; then
                            selected=$((${#options[@]}-1))
                        fi
                        ;;
                    '[B')  # Down arrow
                        selected=$((selected + 1))
                        if [ $selected -ge ${#options[@]} ]; then
                            selected=0
                        fi
                        ;;
                esac
                ;;
            ' ')  # Space - toggle selection
                if [ "${checked[$selected]}" = true ]; then
                    checked[$selected]=false
                else
                    checked[$selected]=true
                fi
                ;;
            '')  # Enter - confirm
                # Show cursor
                tput cnorm
                echo ""
                
                # Return selected indices
                local result=""
                for i in "${!checked[@]}"; do
                    if [ "${checked[$i]}" = true ]; then
                        result="$result $i"
                    fi
                done
                echo "${result## }"
                return 0
                ;;
        esac
    done
}

# Prompt for project name
prompt_project_name() {
    ui_section_title "📁 Project Information" >&2
    
    local project_dir=$(pwd)
    local default_name=$(basename "$project_dir")
    
    echo -e "  Current directory: ${GREEN}$project_dir${NC}" >&2
    echo -e "  Detected name: ${GREEN}$default_name${NC}" >&2
    echo "" >&2
    
    echo -en "${BOLD}Enter project name ${NC}[${GREEN}$default_name${NC}]: " >&2
    read input_name </dev/tty
    echo "${input_name:-$default_name}"
}
