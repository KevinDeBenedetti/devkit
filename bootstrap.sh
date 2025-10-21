#!/bin/bash
set -e

# Main bootstrap script - orchestrates the setup wizard

# Parse command line arguments
VERBOSE=false
DEBUG=false
BRANCH_ARG=""

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
        -b|--branch)
            BRANCH_ARG="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -v, --verbose    Enable verbose output"
            echo "  -d, --debug      Enable debug mode (includes verbose)"
            echo "  -b, --branch     Specify the GitHub branch (default: main)"
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
GITHUB_BRANCH="${BRANCH_ARG:-main}"
BASE_URL="https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_BRANCH}"

# Export for use in generator
export GITHUB_REPO
export GITHUB_BRANCH

echo "Using repository: ${GITHUB_REPO}"
echo "Using branch: ${GITHUB_BRANCH}"
echo ""

# Determine if we're running locally or remotely
# When running via curl | bash, BASH_SOURCE[0] is "bash" or "/bin/bash"
if [[ "${BASH_SOURCE[0]}" == "bash" ]] || [[ "${BASH_SOURCE[0]}" == *"/bash" ]] || [[ ! -d "$(dirname "${BASH_SOURCE[0]}")/lib" ]]; then
    # Running via curl | bash or lib directory doesn't exist
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
else
    # Running locally
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    LIB_DIR="${SCRIPT_DIR}/lib"
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
    
    # Gather configuration
    PROJECT_NAME=$(prompt_project_name)
    log_debug "Project name: $PROJECT_NAME"
    ui_section_separator
    
    IS_MONOREPO=$(prompt_project_structure)
    log_debug "Monorepo: $IS_MONOREPO"
    ui_section_separator
    
    STACK=$(prompt_stack_selection "$IS_MONOREPO")
    log_debug "Stack: $STACK"
    ui_section_separator
    
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
    
    USE_DOCKER=$(prompt_docker_support)
    log_debug "Docker: $USE_DOCKER"
    ui_section_separator
    
    # Confirmation
    ui_summary "$PROJECT_NAME" "$IS_MONOREPO" "$STACK" "$JS_PKG_MANAGER" "$PY_PKG_MANAGER" "$USE_DOCKER"
    
    if ! prompt_confirmation "Continue with this configuration?"; then
        ui_error "Setup cancelled"
        exit 1
    fi
    
    echo ""
    
    # Generate configuration
    log_verbose "Generating configuration..."
    generate_config "$PROJECT_NAME" "$IS_MONOREPO" "$STACK" "$JS_PKG_MANAGER" "$PY_PKG_MANAGER" "$USE_DOCKER"
    
    # Generate and install
    ui_step "Generating Makefile..."
    generate_makefile && ui_success "Makefile generated" || { ui_error "Failed to generate Makefile"; exit 1; }
    echo ""
    
    ui_step "Initializing make library..."
    install_make_library && ui_success "Make library initialized" || { ui_error "Failed to initialize make library"; exit 1; }
    echo ""
    
    if [ "$IS_MONOREPO" = "true" ]; then
        ui_step "Creating monorepo structure..."
        create_monorepo_structure "$STACK" && ui_success "Directories created" || { ui_error "Failed to create directories"; exit 1; }
        echo ""
    fi
    
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