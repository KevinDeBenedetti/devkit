
#!/bin/bash
# Installer - handles installation and file creation

# Install make library
install_make_library() {
    log_verbose "Installing make library..."
    log_debug "Running: make init"
    
    if make init 2>&1 | sed 's/^/  /'; then
        log_verbose "Make library installed successfully"
        return 0
    else
        log_error "Failed to install make library"
        return 1
    fi
}

# Create monorepo directory structure
create_monorepo_structure() {
    local stack=$1
    
    log_verbose "Creating monorepo structure for stack: $stack"
    
    if [[ "$stack" == *"vue"* ]] || [[ "$stack" == *"nuxt"* ]]; then
        log_debug "Creating directory: $CONFIG_CLIENT_DIR"
        mkdir -p "$CONFIG_CLIENT_DIR"
        ui_success "Created $CONFIG_CLIENT_DIR"
    fi
    
    if [[ "$stack" == *"fastapi"* ]]; then
        log_debug "Creating directory: $CONFIG_SERVER_DIR"
        mkdir -p "$CONFIG_SERVER_DIR"
        ui_success "Created $CONFIG_SERVER_DIR"
    fi
}

# Download Dockerfiles
download_dockerfiles() {
    if [ "$CONFIG_USE_DOCKER" = "true" ]; then
        if make dockerfiles 2>&1 | sed 's/^/  /'; then
            return 0
        else
            return 1
        fi
    fi
}

# Create .gitignore if it doesn't exist
create_gitignore() {
    if [ ! -f .gitignore ]; then
        cat > .gitignore << 'EOF'
# Dependencies
node_modules/
__pycache__/
*.pyc
.venv/
venv/

# Build outputs
dist/
build/
.nuxt/
.output/

# Environment
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# DevKit
mk/
EOF
        ui_success "Created .gitignore"
    fi
}

# Create README if it doesn't exist
create_readme() {
    if [ ! -f README.md ]; then
        cat > README.md << EOF
# $CONFIG_PROJECT_NAME

Project generated with DevKit.

## Stack

- $CONFIG_STACK

## Getting Started

\`\`\`bash
# View available commands
make help

# Initialize dependencies
make install

# Start development server
make dev
\`\`\`

## Structure

$([ "$CONFIG_IS_MONOREPO" = "true" ] && echo "This project uses a monorepo structure:" || echo "This project uses a single app structure:")

$([ "$CONFIG_IS_MONOREPO" = "true" ] && cat << 'MONO'
- apps/client: Frontend application
- apps/server: Backend application
MONO
)

## Documentation

For more information about available commands, run:

\`\`\`bash
make help
\`\`\`
EOF
        ui_success "Created README.md"
    fi
}