#!/bin/bash
# UI utilities - colors, formatting, messages

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Logging functions
log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${DIM}[VERBOSE] $1${NC}" >&2
    fi
}

log_debug() {
    if [ "$DEBUG" = true ]; then
        echo -e "${DIM}[DEBUG] $1${NC}" >&2
    fi
}

log_error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

# Header
ui_header() {
    if [ "$USE_GUM" = true ]; then
        clear
        gum_header "$1"
    else
        clear
        echo -e "${BOLD}${BLUE}"
        echo "╔════════════════════════════════════════════════════════╗"
        echo "║                                                        ║"
        echo "║           🚀 $1 🚀              ║"
        echo "║                                                        ║"
        echo "║          Let's configure your project!                 ║"
        echo "║                                                        ║"
        echo "╚════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo ""
    fi
}

# Section separator
ui_section_separator() {
    echo ""
}

# Section title
ui_section_title() {
    if [ "$USE_GUM" = true ]; then
        gum_section_title "$1"
    else
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BOLD}$1${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
    fi
}

# Success message
ui_success() {
    if [ "$USE_GUM" = true ]; then
        gum_success "$1"
    else
        echo -e "  ${GREEN}✓${NC} $1"
    fi
}

# Error message
ui_error() {
    if [ "$USE_GUM" = true ]; then
        gum_error "$1"
    else
        echo -e "${RED}✗ $1${NC}"
    fi
}

# Warning message
ui_warning() {
    if [ "$USE_GUM" = true ]; then
        gum_warning "$1"
    else
        echo -e "${YELLOW}⚠ $1${NC}"
    fi
}

# Info message
ui_info() {
    if [ "$USE_GUM" = true ]; then
        gum_info "$1"
    else
        echo -e "  $1"
    fi
}

# Step message
ui_step() {
    if [ "$USE_GUM" = true ]; then
        gum_step "$1"
    else
        echo -e "${BLUE}==> $1${NC}"
    fi
}

# Summary display
ui_summary() {
    local project_name=$1
    local is_monorepo=$2
    local stack=$3
    local js_pkg=$4
    local py_pkg=$5
    local use_docker=$6
    
    if [ "$USE_GUM" = true ]; then
        gum_summary "$project_name" "$is_monorepo" "$stack" "$js_pkg" "$py_pkg" "$use_docker"
    else
        ui_section_title "📋 Configuration Summary"
        
        echo -e "  ${BOLD}Project:${NC} $project_name"
        echo -e "  ${BOLD}Structure:${NC} $([ "$is_monorepo" = "true" ] && echo "Monorepo" || echo "Single app")"
        echo -e "  ${BOLD}Stack:${NC} $stack"
        [ -n "$js_pkg" ] && echo -e "  ${BOLD}JS Package Manager:${NC} $js_pkg"
        [ -n "$py_pkg" ] && echo -e "  ${BOLD}Python Package Manager:${NC} $py_pkg"
        echo -e "  ${BOLD}Docker:${NC} $use_docker"
        
        echo ""
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
    fi
}

# Final success message
ui_success_message() {
    local stack=$1
    local use_docker=$2
    
    if [ "$USE_GUM" = true ]; then
        gum_success_message "$stack" "$use_docker"
    else
        echo -e "${GREEN}"
        echo "╔════════════════════════════════════════════════════════╗"
        echo "║                                                        ║"
        echo "║              ✨ Setup Complete! ✨                    ║"
        echo "║                                                        ║"
        echo "╚════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo ""
        echo -e "${BOLD}Next steps:${NC}"
        echo ""
        echo -e "  ${CYAN}1.${NC} View available commands:"
        echo -e "     ${GREEN}make help${NC}"
        echo ""
        
        if [ "$use_docker" = "true" ]; then
            echo -e "  ${CYAN}2.${NC} Download Dockerfiles:"
            echo -e "     ${GREEN}make dockerfiles${NC}"
            echo ""
        fi
        
        echo -e "  ${CYAN}3.${NC} Start developing:"
        
        if [[ "$stack" == *"vue"* ]] || [[ "$stack" == *"nuxt"* ]]; then
            echo -e "     ${GREEN}make install-client${NC}  # Install frontend dependencies"
            echo -e "     ${GREEN}make dev-client${NC}      # Start frontend dev server"
        fi
        
        if [[ "$stack" == *"fastapi"* ]]; then
            echo -e "     ${GREEN}make install-server${NC}  # Install backend dependencies"
            echo -e "     ${GREEN}make dev-server${NC}      # Start backend dev server"
        fi
        
        echo ""
        echo -e "${BLUE}Happy coding! 🚀${NC}"
        echo ""
    fi
}