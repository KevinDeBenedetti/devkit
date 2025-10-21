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
    
    # Force output to be displayed before reading input
    echo -en "${BOLD}Enter project name ${NC}[${GREEN}$default_name${NC}]: " >&2
    
    # Read from terminal device with proper input handling
    local input_name=""
    IFS= read -r input_name </dev/tty
    
    echo "${input_name:-$default_name}"
}

# Prompt for project structure
prompt_project_structure() {
    echo "" >&2
    select_option "Select project structure:" \
        "Monorepo (apps/client + apps/server)" \
        "Single app (all in root directory)" >&2
    
    local choice=$?
    echo "" >&2
    
    if [ $choice -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} Monorepo structure selected" >&2
        echo "true"
    else
        echo -e "  ${GREEN}✓${NC} Single app structure selected" >&2
        echo "false"
    fi
}

# Prompt for stack selection
prompt_stack_selection() {
    local is_monorepo=$1
    local stack=""
    
    # Frontend selection
    echo "" >&2
    select_option "Select frontend framework:" \
        "Vue.js" \
        "Nuxt.js" \
        "None" >&2
    
    local frontend_choice=$?
    
    case $frontend_choice in
        0) stack="vue" ;;
        1) stack="nuxt" ;;
        2) stack="" ;;
    esac
    
    # Backend selection
    echo "" >&2
    select_option "Select backend framework:" \
        "FastAPI" \
        "None" >&2
    
    local backend_choice=$?
    
    if [ $backend_choice -eq 0 ]; then
        stack="$stack fastapi"
    fi
    
    # Husky selection
    echo "" >&2
    select_option "Configure git hooks:" \
        "Enable Husky" \
        "Skip Husky" >&2
    
    local husky_choice=$?
    
    if [ $husky_choice -eq 0 ]; then
        stack="$stack husky"
    fi
    
    echo "${stack## }"
}

# Prompt for JavaScript package manager
prompt_js_package_manager() {
    echo "" >&2
    select_option "Select JavaScript package manager:" \
        "pnpm (recommended)" \
        "npm" \
        "yarn" \
        "bun" >&2
    
    local choice=$?
    echo "" >&2
    
    case $choice in
        0) echo -e "  ${GREEN}✓${NC} Using pnpm" >&2; echo "pnpm" ;;
        1) echo -e "  ${GREEN}✓${NC} Using npm" >&2; echo "npm" ;;
        2) echo -e "  ${GREEN}✓${NC} Using yarn" >&2; echo "yarn" ;;
        3) echo -e "  ${GREEN}✓${NC} Using bun" >&2; echo "bun" ;;
    esac
}

# Prompt for Python package manager
prompt_python_package_manager() {
    echo "" >&2
    select_option "Select Python package manager:" \
        "uv (recommended)" \
        "poetry" \
        "pip" >&2
    
    local choice=$?
    echo "" >&2
    
    case $choice in
        0) echo -e "  ${GREEN}✓${NC} Using uv" >&2; echo "uv" ;;
        1) echo -e "  ${GREEN}✓${NC} Using poetry" >&2; echo "poetry" ;;
        2) echo -e "  ${GREEN}✓${NC} Using pip" >&2; echo "pip" ;;
    esac
}

# Prompt for Docker support
prompt_docker_support() {
    echo "" >&2
    select_option "Configure Docker:" \
        "Enable Docker support" \
        "Skip Docker" >&2
    
    local choice=$?
    echo "" >&2
    
    if [ $choice -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} Docker enabled" >&2
        echo "true"
    else
        echo -e "  ${GREEN}✓${NC} Docker skipped" >&2
        echo "false"
    fi
}

# Prompt for confirmation
prompt_confirmation() {
    local message="$1"
    
    echo "" >&2
    select_option "$message" \
        "Yes, continue" \
        "No, cancel" >&2
    
    local choice=$?
    
    if [ $choice -eq 0 ]; then
        return 0
    else
        return 1
    fi
}
