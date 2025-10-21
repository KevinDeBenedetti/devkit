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
        
        # Read key
        read -rsn1 key
        
        case "$key" in
            $'\x1b')  # ESC sequence
                read -rsn2 key
                case "$key" in
                    '[A')  # Up arrow
                        ((selected--))
                        if [ $selected -lt 0 ]; then
                            selected=$((${#options[@]}-1))
                        fi
                        ;;
                    '[B')  # Down arrow
                        ((selected++))
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
        
        # Read key
        read -rsn1 key
        
        case "$key" in
            $'\x1b')  # ESC sequence
                read -rsn2 key
                case "$key" in
                    '[A')  # Up arrow
                        ((selected--))
                        if [ $selected -lt 0 ]; then
                            selected=$((${#options[@]}-1))
                        fi
                        ;;
                    '[B')  # Down arrow
                        ((selected++))
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

# Prompt for project structure
prompt_project_structure() {
    ui_section_title "🏗️  Project Structure" >&2
    
    local options=(
        "Monorepo (apps/client + apps/server)"
        "Single app (all in root directory)"
    )
    
    select_option "Select project structure:" "${options[@]}" >&2
    local choice=$?
    
    case $choice in
        0)
            ui_success "Monorepo structure selected" >&2
            echo "true"
            ;;
        1)
            ui_success "Single app structure selected" >&2
            echo "false"
            ;;
    esac
}

# Prompt for stack selection
prompt_stack_selection() {
    local is_monorepo=$1
    ui_section_title "📚 Technology Stack" >&2
    
    # Frontend
    echo -e "${BOLD}Frontend Framework${NC}" >&2
    echo "" >&2
    
    local frontend_options=(
        "Vue.js"
        "Nuxt.js"
        "None"
    )
    
    select_option "Select frontend framework:" "${frontend_options[@]}" >&2
    local frontend_choice=$?
    
    local frontend=""
    case $frontend_choice in
        0) frontend="vue"; ui_success "Vue.js selected" >&2 ;;
        1) frontend="nuxt"; ui_success "Nuxt.js selected" >&2 ;;
        2) ui_success "No frontend framework" >&2 ;;
    esac
    echo "" >&2
    
    # Backend
    echo -e "${BOLD}Backend Framework${NC}" >&2
    echo "" >&2
    
    local backend_options=(
        "FastAPI"
        "None"
    )
    
    select_option "Select backend framework:" "${backend_options[@]}" >&2
    local backend_choice=$?
    
    local backend=""
    case $backend_choice in
        0) backend="fastapi"; ui_success "FastAPI selected" >&2 ;;
        1) ui_success "No backend framework" >&2 ;;
    esac
    echo "" >&2
    
    # Git hooks
    echo -e "${BOLD}Git Hooks${NC}" >&2
    echo "" >&2
    
    local husky_options=(
        "Enable Husky"
        "Skip Husky"
    )
    
    select_option "Configure git hooks:" "${husky_options[@]}" >&2
    local husky_choice=$?
    
    local husky=""
    if [ $husky_choice -eq 0 ]; then
        husky="husky"
        ui_success "Husky enabled" >&2
    else
        ui_success "Husky disabled" >&2
    fi
    
    # Build stack string
    local stack=()
    [ -n "$frontend" ] && stack+=("$frontend")
    [ -n "$backend" ] && stack+=("$backend")
    [ -n "$husky" ] && stack+=("$husky")
    
    if [ ${#stack[@]} -eq 0 ]; then
        ui_error "No stack selected!" >&2
        exit 1
    fi
    
    echo "${stack[*]}"
}

# Prompt for JS package manager
prompt_js_package_manager() {
    ui_section_title "📦 JavaScript Package Manager" >&2
    
    local options=(
        "pnpm (recommended)"
        "npm"
        "yarn"
        "bun"
    )
    
    select_option "Select JavaScript package manager:" "${options[@]}" >&2
    local choice=$?
    
    local manager="pnpm"
    case $choice in
        0) manager="pnpm" ;;
        1) manager="npm" ;;
        2) manager="yarn" ;;
        3) manager="bun" ;;
    esac
    
    ui_success "Using $manager" >&2
    echo "$manager"
}

# Prompt for Python package manager
prompt_python_package_manager() {
    ui_section_title "🐍 Python Package Manager" >&2
    
    local options=(
        "uv (recommended)"
        "poetry"
        "pip"
    )
    
    select_option "Select Python package manager:" "${options[@]}" >&2
    local choice=$?
    
    local manager="uv"
    case $choice in
        0) manager="uv" ;;
        1) manager="poetry" ;;
        2) manager="pip" ;;
    esac
    
    ui_success "Using $manager" >&2
    echo "$manager"
}

# Prompt for Docker support
prompt_docker_support() {
    ui_section_title "🐳 Docker Support" >&2
    
    local options=(
        "Enable Docker support"
        "Skip Docker"
    )
    
    select_option "Configure Docker:" "${options[@]}" >&2
    local choice=$?
    
    if [ $choice -eq 0 ]; then
        ui_success "Docker enabled" >&2
        echo "true"
    else
        ui_success "Docker disabled" >&2
        echo "false"
    fi
}

# Prompt for confirmation
prompt_confirmation() {
    local message=$1
    
    local options=(
        "Yes, continue"
        "No, cancel"
    )
    
    select_option "$message" "${options[@]}" >&2
    local choice=$?
    
    [ $choice -eq 0 ]
}