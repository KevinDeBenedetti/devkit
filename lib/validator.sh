#!/bin/bash
# Validator - checks prerequisites and system requirements

# Required tools
REQUIRED_TOOLS=(
    "git:Git version control system"
    "make:GNU Make build tool"
    "curl:Command line tool for transferring data"
)

# Optional tools (recommended but not required)
OPTIONAL_TOOLS=(
    "gum:Charmbracelet Gum - Enhanced terminal UI"
)

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get version of a tool
get_tool_version() {
    local tool=$1
    case $tool in
        git)
            git --version 2>/dev/null | awk '{print $3}'
            ;;
        make)
            make --version 2>/dev/null | head -n1 | awk '{print $3}'
            ;;
        curl)
            curl --version 2>/dev/null | head -n1 | awk '{print $2}'
            ;;
        gum)
            gum --version 2>/dev/null | awk '{print $3}'
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Validate single prerequisite
validate_tool() {
    local tool_info=$1
    local tool=${tool_info%%:*}
    local description=${tool_info#*:}
    
    log_verbose "Checking for $tool..."
    
    if command_exists "$tool"; then
        local version=$(get_tool_version "$tool")
        ui_success "$tool is installed (version: $version)"
        log_verbose "  Path: $(command -v $tool)"
        return 0
    else
        ui_error "$tool is not installed"
        echo "  Description: $description"
        echo "  Install: $(get_install_instructions "$tool")"
        return 1
    fi
}

# Get installation instructions for a tool
get_install_instructions() {
    local tool=$1
    
    case $tool in
        git)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "brew install git"
            elif [[ -f /etc/debian_version ]]; then
                echo "sudo apt-get install git"
            elif [[ -f /etc/redhat-release ]]; then
                echo "sudo yum install git"
            else
                echo "Visit https://git-scm.com/downloads"
            fi
            ;;
        make)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "xcode-select --install"
            elif [[ -f /etc/debian_version ]]; then
                echo "sudo apt-get install build-essential"
            elif [[ -f /etc/redhat-release ]]; then
                echo "sudo yum groupinstall 'Development Tools'"
            else
                echo "Install build tools for your system"
            fi
            ;;
        curl)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "brew install curl"
            elif [[ -f /etc/debian_version ]]; then
                echo "sudo apt-get install curl"
            elif [[ -f /etc/redhat-release ]]; then
                echo "sudo yum install curl"
            else
                echo "Install curl for your system"
            fi
            ;;
        gum)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "brew install gum"
            elif [[ -f /etc/debian_version ]]; then
                echo "See https://github.com/charmbracelet/gum#installation"
            elif [[ -f /etc/redhat-release ]]; then
                echo "See https://github.com/charmbracelet/gum#installation"
            else
                echo "See https://github.com/charmbracelet/gum#installation"
            fi
            ;;
        *)
            echo "See documentation"
            ;;
    esac
}

# Validate all prerequisites
validate_prerequisites() {
    ui_section_title "🔍 Validating Prerequisites"
    
    local all_valid=true
    
    for tool_info in "${REQUIRED_TOOLS[@]}"; do
        if ! validate_tool "$tool_info"; then
            all_valid=false
        fi
    done
    
    echo ""
    
    # Check optional tools
    if [ ${#OPTIONAL_TOOLS[@]} -gt 0 ]; then
        echo -e "${DIM}Optional tools:${NC}"
        for tool_info in "${OPTIONAL_TOOLS[@]}"; do
            validate_tool "$tool_info" || true  # Don't fail on optional tools
        done
        echo ""
    fi
    
    if [ "$all_valid" = true ]; then
        ui_success "All prerequisites are satisfied!"
        return 0
    else
        ui_error "Some prerequisites are missing. Please install them and try again."
        return 1
    fi
}

# Check if we're in a git repository
validate_git_repo() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        log_verbose "Current directory is a git repository"
        return 0
    else
        log_verbose "Current directory is NOT a git repository"
        return 1
    fi
}

# Validate directory is writable
validate_writable() {
    local dir=${1:-.}
    
    if [ -w "$dir" ]; then
        log_verbose "Directory $dir is writable"
        return 0
    else
        ui_error "Directory $dir is not writable"
        return 1
    fi
}

# Check disk space (optional, warns if low)
check_disk_space() {
    log_verbose "Checking available disk space..."
    
    # Get available space in KB
    local available_kb=$(df -k . | awk 'NR==2 {print $4}')
    local available_mb=$((available_kb / 1024))
    
    log_verbose "Available disk space: ${available_mb}MB"
    
    if [ $available_mb -lt 100 ]; then
        ui_warning "Low disk space: ${available_mb}MB available"
        ui_warning "DevKit installation may require at least 100MB"
    fi
}

# Validate network connectivity
validate_network() {
    log_verbose "Checking network connectivity..."
    
    if curl -s --head --request GET https://github.com | grep "200 OK" > /dev/null 2>&1; then
        log_verbose "Network connectivity: OK"
        return 0
    else
        ui_warning "Cannot reach GitHub. Check your internet connection."
        return 1
    fi
}