#!/bin/bash
# Generator - creates configuration and files

# Generate configuration object
generate_config() {
    local project_name=$1
    local is_monorepo=$2
    local stack=$3
    local js_pkg=$4
    local py_pkg=$5
    local use_docker=$6
    local custom_client_dir=$7
    local custom_server_dir=$8
    
    # Determine directories - use custom paths if provided, otherwise use defaults
    local client_dir="${custom_client_dir:-.}"
    local server_dir="${custom_server_dir:-.}"
    
    # If no custom paths but monorepo, use conventional structure
    if [ "$is_monorepo" = "true" ] && [ -z "$custom_client_dir" ] && [ -z "$custom_server_dir" ]; then
        client_dir="./apps/client"
        server_dir="./apps/server"
    fi
    
    # Export as environment variables for other functions
    export CONFIG_PROJECT_NAME="$project_name"
    export CONFIG_IS_MONOREPO="$is_monorepo"
    export CONFIG_STACK="$stack"
    export CONFIG_JS_PKG="$js_pkg"
    export CONFIG_PY_PKG="$py_pkg"
    export CONFIG_USE_DOCKER="$use_docker"
    export CONFIG_CLIENT_DIR="$client_dir"
    export CONFIG_SERVER_DIR="$server_dir"
}

# Generate Makefile
generate_makefile() {
    log_verbose "Generating Makefile with configuration:"
    log_verbose "  Project: $CONFIG_PROJECT_NAME"
    log_verbose "  Stack: $CONFIG_STACK"
    log_verbose "  Monorepo: $CONFIG_IS_MONOREPO"
    
    cat > Makefile << EOF
# Auto-generated Makefile by DevKit
# Project: $CONFIG_PROJECT_NAME
# Generated on: $(date)
# Structure: $([ "$CONFIG_IS_MONOREPO" = "true" ] && echo "Monorepo" || echo "Single app")

# Project configuration
PROJECT_NAME := $CONFIG_PROJECT_NAME
STACK := $CONFIG_STACK

# Make library configuration
MK_DIR := mk
MK_REPO := https://github.com/KevinDeBenedetti/devkit.git
MK_BRANCH := main

EOF

    # Add stack-specific configuration
    add_vue_config
    add_nuxt_config
    add_fastapi_config
    add_husky_config
    
    # Add Docker configuration
    cat >> Makefile << EOF
# Docker configuration
DOCKER ?= $CONFIG_USE_DOCKER

EOF
    
    # Add includes
    cat >> Makefile << 'EOF'
# Include make library files
INCLUDES := $(MK_DIR)/common.mk $(MK_DIR)/init.mk $(addprefix $(MK_DIR)/,$(addsuffix .mk,$(STACK)))

-include $(INCLUDES)
EOF
}

# Add Vue configuration
add_vue_config() {
    if [[ "$CONFIG_STACK" == *"vue"* ]]; then
        cat >> Makefile << EOF
# VUE
VUE_DIR := $CONFIG_CLIENT_DIR
JS_PKG_MANAGER := $CONFIG_JS_PKG
VUE_DOCKERFILE := https://raw.githubusercontent.com/KevinDeBenedetti/devkit/main/docker/vue/Dockerfile

EOF
    fi
}

# Add Nuxt configuration
add_nuxt_config() {
    if [[ "$CONFIG_STACK" == *"nuxt"* ]]; then
        cat >> Makefile << EOF
# NUXT
NUXT_DIR := $CONFIG_CLIENT_DIR
JS_PKG_MANAGER := $CONFIG_JS_PKG
NUXT_DOCKERFILE := https://raw.githubusercontent.com/KevinDeBenedetti/devkit/main/docker/nuxt/Dockerfile

EOF
    fi
}

# Add FastAPI configuration
add_fastapi_config() {
    if [[ "$CONFIG_STACK" == *"fastapi"* ]]; then
        cat >> Makefile << EOF
# FASTAPI
FASTAPI_DIR := $CONFIG_SERVER_DIR
PY_PKG_MANAGER := $CONFIG_PY_PKG
FASTAPI_DOCKERFILE := https://raw.githubusercontent.com/KevinDeBenedetti/devkit/main/docker/fastapi/Dockerfile

EOF
    fi
}

# Add Husky configuration
add_husky_config() {
    if [[ "$CONFIG_STACK" == *"husky"* ]]; then
        cat >> Makefile << EOF
# HUSKY
HUSKY_DIR := $CONFIG_CLIENT_DIR

EOF
    fi
}