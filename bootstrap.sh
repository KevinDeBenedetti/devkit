#!/bin/bash
set -e

# Main bootstrap script - orchestrates the setup wizard

# Parse command line arguments
VERBOSE=false
DEBUG=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -d|--debug)
            DEBUG=true
            VERBOSE=true
            set -x
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -v, --verbose    Enable verbose output"
            echo "  -d, --debug      Enable debug mode (includes verbose)"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Export for use in other scripts
export VERBOSE
export DEBUG

# Configuration
GITHUB_REPO="KevinDeBenedetti/devkit"
GITHUB_BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_BRANCH}"

# Determine if we're running locally or remotely
if [ -f "${BASH_SOURCE[0]}" ]; then
    # Running locally
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    LIB_DIR="${SCRIPT_DIR}/lib"
else
    # Running via curl | bash
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT
    LIB_DIR="${TEMP_DIR}/lib"
    mkdir -p "${LIB_DIR}"
    
    # Download all library files
    echo "Downloading required files..."
    for file in ui.sh validator.sh prompts.sh generator.sh installer.sh; do
        if ! curl -fsSL "${BASE_URL}/lib/${file}" -o "${LIB_DIR}/${file}"; then
            echo "Error: Failed to download lib/${file}"
            exit 1
        fi
    done
fi

# Source utility modules
source "${LIB_DIR}/ui.sh"
source "${LIB_DIR}/validator.sh"
source "${LIB_DIR}/prompts.sh"
source "${LIB_DIR}/generator.sh"
source "${LIB_DIR}/installer.sh"

# Main setup flow
main() {
    ui_header "DevKit Setup Wizard"
    
    # Validate prerequisites
    log_verbose "Checking prerequisites..."
    if ! validate_prerequisites; then
        ui_error "Prerequisites check failed. Please install missing tools and try again."
        exit 1
    fi
    log_verbose "All prerequisites satisfied"
    ui_section_separator
    
    # Step 1: Project info
    log_verbose "Starting project configuration..."
    PROJECT_NAME=$(prompt_project_name)
    log_debug "Project name selected: $PROJECT_NAME"
    ui_section_separator
    
    # Step 2: Project structure
    IS_MONOREPO=$(prompt_project_structure)
    log_debug "Monorepo selected: $IS_MONOREPO"
    ui_section_separator
    
    # Step 3: Stack selection
    STACK=$(prompt_stack_selection "$IS_MONOREPO")
    log_debug "Stack selected: $STACK"
    ui_section_separator
    
    # Step 4: Package managers
    if has_frontend "$STACK"; then
        JS_PKG_MANAGER=$(prompt_js_package_manager)
        log_debug "JS package manager: $JS_PKG_MANAGER"
        ui_section_separator
    fi
    
    if has_backend "$STACK"; then
        PY_PKG_MANAGER=$(prompt_python_package_manager)
        log_debug "Python package manager: $PY_PKG_MANAGER"
        ui_section_separator
    fi
    
    # Step 5: Docker support
    USE_DOCKER=$(prompt_docker_support)
    log_debug "Docker enabled: $USE_DOCKER"
    ui_section_separator
    
    # Step 6: Summary and confirmation
    ui_summary "$PROJECT_NAME" "$IS_MONOREPO" "$STACK" "$JS_PKG_MANAGER" "$PY_PKG_MANAGER" "$USE_DOCKER"
    
    if ! prompt_confirmation "Continue with this configuration?"; then
        ui_error "Setup cancelled"
        exit 1
    fi
    
    echo ""
    
    # Generate configuration
    log_verbose "Generating configuration object..."
    CONFIG=$(generate_config \
        "$PROJECT_NAME" \
        "$IS_MONOREPO" \
        "$STACK" \
        "$JS_PKG_MANAGER" \
        "$PY_PKG_MANAGER" \
        "$USE_DOCKER")
    log_debug "Configuration generated"
    
    # Generate Makefile
    ui_step "Generating Makefile..."
    if generate_makefile "$CONFIG"; then
        ui_success "Makefile generated"
    else
        ui_error "Failed to generate Makefile"
        exit 1
    fi
    echo ""
    
    # Initialize make library
    ui_step "Initializing make library..."
    if install_make_library; then
        ui_success "Make library initialized"
    else
        ui_error "Failed to initialize make library"
        exit 1
    fi
    echo ""
    
    # Create directories if needed
    if [ "$IS_MONOREPO" = "true" ]; then
        ui_step "Creating monorepo structure..."
        if create_monorepo_structure "$STACK"; then
            ui_success "Directories created"
        else
            ui_error "Failed to create directories"
            exit 1
        fi
        echo ""
    fi
    
    # Success
    log_verbose "Setup completed successfully"
    ui_success_message "$STACK" "$USE_DOCKER"
}

# Helper functions
has_frontend() {
    [[ "$1" == *"vue"* ]] || [[ "$1" == *"nuxt"* ]]
}

has_backend() {
    [[ "$1" == *"fastapi"* ]]
}

# Run main
main "$@"