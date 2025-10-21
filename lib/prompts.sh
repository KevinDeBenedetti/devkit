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
    
    read -p "$(echo -e ${BOLD}Enter project name ${NC}[${GREEN}$default_name${NC}]: )" input_name
    echo "${input_name:-$default_name}"
}

# Prompt for project structure
prompt_project_structure() {
    ui_section_title "🏗️  Project Structure"
    
    echo "  1) Monorepo (apps/client + apps/server)"
    echo "  2) Single app (all in root directory)"
    echo ""
    
    read -p "$(echo -e ${BOLD}Select structure ${NC}[1-2]: )" choice
    
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
    
    read -p "$(echo -e ${BOLD}Select frontend ${NC}[1-3]: )" frontend_choice
    
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
    
    read -p "$(echo -e ${BOLD}Select backend ${NC}[1-2]: )" backend_choice
    
    local backend=""
    case $backend_choice in
        1) backend="fastapi"; ui_success "FastAPI selected" ;;
        2) ui_success "No backend framework" ;;
        *) ui_warning "Invalid choice, skipping backend" ;;
    esac
    echo ""
    
    # Git hooks
    echo -e "${BOLD}Git Hooks:${NC}"
    read -p "$(echo -e ${BOLD}Use Husky for git hooks? ${NC}[y/N]: )" use_husky
    
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
    
    read -p "$(echo -e ${BOLD}Select JS package manager ${NC}[1-4]: )" choice
    
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
    
    read -p "$(echo -e ${BOLD}Select Python package manager ${NC}[1-3]: )" choice
    
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
    
    read -p "$(echo -e ${BOLD}Enable Docker support? ${NC}[Y/n]: )" use_docker
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
    read -p "$(echo -e ${BOLD}$message ${NC}[Y/n]: )" confirm
    confirm=${confirm:-y}
    [[ $confirm =~ ^[Yy]$ ]]
}