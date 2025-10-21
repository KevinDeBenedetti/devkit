#!/bin/bash
# User prompts - all interactive questions

# Prompt for project name
prompt_project_name() {
    ui_section_title "📁 Project Information"
    
    local project_dir=$(pwd)
    local default_name=$(basename "$project_dir")
    
    echo -e "  Current directory: ${GREEN}$project_dir${NC}"
    echo -e "  Detected name: ${GREEN}$default_name${NC}"
    echo ""
    
    echo -en "${BOLD}Enter project name ${NC}[${GREEN}$default_name${NC}]: "
    read input_name </dev/tty
    echo "${input_name:-$default_name}"
}

# Prompt for project structure
prompt_project_structure() {
    ui_section_title "🏗️  Project Structure"
    
    echo "  1) Monorepo (apps/client + apps/server)"
    echo "  2) Single app (all in root directory)"
    echo ""
    
    echo -en "${BOLD}Select structure ${NC}[1-2]: "
    read choice </dev/tty
    
    case $choice in
        1)
            ui_success "Monorepo structure selected"
            echo "true"
            ;;
        2)
            ui_success "Single app structure selected"
            echo "false"
            ;;
        *)
            ui_warning "Invalid choice, using single app"
            echo "false"
            ;;
    esac
}

# Prompt for stack selection
prompt_stack_selection() {
    local is_monorepo=$1
    ui_section_title "📚 Technology Stack"
    
    echo "Select the technologies for your project:"
    echo ""
    
    # Frontend
    echo -e "${BOLD}Frontend:${NC}"
    echo "  1) Vue.js"
    echo "  2) Nuxt.js"
    echo "  3) None"
    echo ""
    
    echo -en "${BOLD}Select frontend ${NC}[1-3]: "
    read frontend_choice </dev/tty
    
    local frontend=""
    case $frontend_choice in
        1) frontend="vue"; ui_success "Vue.js selected" ;;
        2) frontend="nuxt"; ui_success "Nuxt.js selected" ;;
        3) ui_success "No frontend framework" ;;
        *) ui_warning "Invalid choice, skipping frontend" ;;
    esac
    echo ""
    
    # Backend
    echo -e "${BOLD}Backend:${NC}"
    echo "  1) FastAPI"
    echo "  2) None"
    echo ""
    
    echo -en "${BOLD}Select backend ${NC}[1-2]: "
    read backend_choice </dev/tty
    
    local backend=""
    case $backend_choice in
        1) backend="fastapi"; ui_success "FastAPI selected" ;;
        2) ui_success "No backend framework" ;;
        *) ui_warning "Invalid choice, skipping backend" ;;
    esac
    echo ""
    
    # Git hooks
    echo -e "${BOLD}Git Hooks:${NC}"
    echo -en "${BOLD}Use Husky for git hooks? ${NC}[y/N]: "
    read use_husky </dev/tty
    
    local husky=""
    if [[ $use_husky =~ ^[Yy]$ ]]; then
        husky="husky"
        ui_success "Husky enabled"
    else
        ui_success "Husky disabled"
    fi
    
    # Build stack string
    local stack=()
    [ -n "$frontend" ] && stack+=("$frontend")
    [ -n "$backend" ] && stack+=("$backend")
    [ -n "$husky" ] && stack+=("$husky")
    
    if [ ${#stack[@]} -eq 0 ]; then
        ui_error "No stack selected!"
        exit 1
    fi
    
    echo "${stack[*]}"
}

# Prompt for JS package manager
prompt_js_package_manager() {
    ui_section_title "📦 JavaScript Package Manager"
    
    echo "  1) pnpm (recommended)"
    echo "  2) npm"
    echo "  3) yarn"
    echo "  4) bun"
    echo ""
    
    echo -en "${BOLD}Select JS package manager ${NC}[1-4]: "
    read choice </dev/tty
    
    local manager="pnpm"
    case $choice in
        1) manager="pnpm" ;;
        2) manager="npm" ;;
        3) manager="yarn" ;;
        4) manager="bun" ;;
        *) manager="pnpm" ;;
    esac
    
    ui_success "Using $manager"
    echo "$manager"
}

# Prompt for Python package manager
prompt_python_package_manager() {
    ui_section_title "🐍 Python Package Manager"
    
    echo "  1) uv (recommended)"
    echo "  2) poetry"
    echo "  3) pip"
    echo ""
    
    echo -en "${BOLD}Select Python package manager ${NC}[1-3]: "
    read choice </dev/tty
    
    local manager="uv"
    case $choice in
        1) manager="uv" ;;
        2) manager="poetry" ;;
        3) manager="pip" ;;
        *) manager="uv" ;;
    esac
    
    ui_success "Using $manager"
    echo "$manager"
}

# Prompt for Docker support
prompt_docker_support() {
    ui_section_title "🐳 Docker Support"
    
    echo -en "${BOLD}Enable Docker support? ${NC}[Y/n]: "
    read use_docker </dev/tty
    use_docker=${use_docker:-y}
    
    if [[ $use_docker =~ ^[Yy]$ ]]; then
        ui_success "Docker enabled"
        echo "true"
    else
        ui_success "Docker disabled"
        echo "false"
    fi
}

# Prompt for confirmation
prompt_confirmation() {
    local message=$1
    echo -en "${BOLD}$message ${NC}[Y/n]: "
    read confirm </dev/tty
    confirm=${confirm:-y}
    [[ $confirm =~ ^[Yy]$ ]]
}