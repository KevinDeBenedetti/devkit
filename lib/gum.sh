#!/bin/bash
# Gum integration - modern terminal UI with charmbracelet/gum

# Check if gum is available
USE_GUM=false
if command -v gum >/dev/null 2>&1; then
    USE_GUM=true
fi

# Export for use in other scripts
export USE_GUM

# Gum-based input prompt
gum_input() {
    local prompt="$1"
    local default="$2"
    local placeholder="${3:-$default}"
    
    if [ -n "$default" ]; then
        gum input --placeholder "$placeholder" --value "$default" --prompt "$prompt "
    else
        gum input --placeholder "$placeholder" --prompt "$prompt "
    fi
}

# Gum-based select (single choice)
gum_select() {
    local title="$1"
    shift
    local options=("$@")
    
    echo "$title" >&2
    gum choose "${options[@]}"
}

# Gum-based select with index return
gum_select_index() {
    local title="$1"
    shift
    local options=("$@")
    
    echo "$title" >&2
    local selected=$(gum choose "${options[@]}")
    
    # Find index of selected option
    for i in "${!options[@]}"; do
        if [ "${options[$i]}" = "$selected" ]; then
            return $i
        fi
    done
    
    return 0
}

# Gum-based confirmation
gum_confirm() {
    local message="$1"
    local default="${2:-No}"  # Default to No for safety
    
    if [ "$default" = "Yes" ]; then
        gum confirm "$message" --default=true
    else
        gum confirm "$message" --default=false
    fi
}

# Gum-based multi-select
gum_multi_select() {
    local title="$1"
    shift
    local options=("$@")
    
    echo "$title" >&2
    echo "(Use space to select, enter to confirm)" >&2
    gum choose --no-limit "${options[@]}"
}

# Gum-styled header
gum_header() {
    local title="$1"
    
    gum style \
        --border double \
        --border-foreground 212 \
        --padding "1 2" \
        --margin "1 0" \
        --align center \
        "🚀 $title 🚀" \
        "" \
        "Let's configure your project!"
}

# Gum-styled section title
gum_section_title() {
    local title="$1"
    
    echo ""
    gum style \
        --foreground 212 \
        --border-foreground 212 \
        --border normal \
        --padding "0 1" \
        "$title"
    echo ""
}

# Gum-styled success message
gum_success() {
    local message="$1"
    gum style --foreground 10 "✓ $message"
}

# Gum-styled error message
gum_error() {
    local message="$1"
    gum style --foreground 9 "✗ $message"
}

# Gum-styled warning message
gum_warning() {
    local message="$1"
    gum style --foreground 11 "⚠ $message"
}

# Gum-styled info message
gum_info() {
    local message="$1"
    echo "  $message"
}

# Gum-styled step message
gum_step() {
    local message="$1"
    gum style --foreground 12 "==> $message"
}

# Gum spinner for long operations
gum_spin() {
    local title="$1"
    local command="$2"
    
    gum spin --spinner dot --title "$title" -- bash -c "$command"
}

# Gum-based summary display
gum_summary() {
    local project_name=$1
    local is_monorepo=$2
    local stack=$3
    local js_pkg=$4
    local py_pkg=$5
    local use_docker=$6
    
    echo ""
    
    local summary="Project: $project_name
Structure: $([ "$is_monorepo" = "true" ] && echo "Monorepo" || echo "Single app")
Stack: $stack"
    
    [ -n "$js_pkg" ] && summary="$summary
JS Package Manager: $js_pkg"
    
    [ -n "$py_pkg" ] && summary="$summary
Python Package Manager: $py_pkg"
    
    summary="$summary
Docker: $use_docker"
    
    gum style \
        --border double \
        --border-foreground 212 \
        --padding "1 2" \
        --margin "1 0" \
        "📋 Configuration Summary" \
        "" \
        "$summary"
    
    echo ""
}

# Gum-based final success message
gum_success_message() {
    local stack=$1
    local use_docker=$2
    
    echo ""
    
    gum style \
        --border double \
        --border-foreground 10 \
        --padding "1 2" \
        --margin "1 0" \
        --align center \
        "✨ Setup Complete! ✨"
    
    echo ""
    echo "$(gum style --bold 'Next steps:')"
    echo ""
    echo "  $(gum style --foreground 14 '1.') View available commands:"
    echo "     $(gum style --foreground 10 'make help')"
    echo ""
    
    if [ "$use_docker" = "true" ]; then
        echo "  $(gum style --foreground 14 '2.') Download Dockerfiles:"
        echo "     $(gum style --foreground 10 'make dockerfiles')"
        echo ""
    fi
    
    echo "  $(gum style --foreground 14 '3.') Start developing:"
    
    if [[ "$stack" == *"vue"* ]] || [[ "$stack" == *"nuxt"* ]]; then
        echo "     $(gum style --foreground 10 'make install-client')  # Install frontend dependencies"
        echo "     $(gum style --foreground 10 'make dev-client')      # Start frontend dev server"
    fi
    
    if [[ "$stack" == *"fastapi"* ]]; then
        echo "     $(gum style --foreground 10 'make install-server')  # Install backend dependencies"
        echo "     $(gum style --foreground 10 'make dev-server')      # Start backend dev server"
    fi
    
    echo ""
    echo "$(gum style --foreground 12 'Happy coding! 🚀')"
    echo ""
}
