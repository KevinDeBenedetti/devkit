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
    
    # Determine directories
    local client_dir="."
    local server_dir="."
    
    if [ "$is_monorepo" = "true" ]; then
        client_dir="./apps/client"
        server_dir="./apps/server"
    fi
    
    # Export configuration
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
    log_verbose "Generating Makefile:"
    log_verbose "  Project: $CONFIG_PROJECT_NAME"
    log_verbose "  Stack: $CONFIG_STACK"
    log_verbose "  Monorepo: $CONFIG_IS_MONOREPO"
    log_verbose "  Repo: ${GITHUB_REPO}"
    log_verbose "  Branch: ${GITHUB_BRANCH}"
    
    cat > Makefile << EOF
# Auto-generated Makefile by DevKit
# Project: $CONFIG_PROJECT_NAME
# Generated: $(date)
# Structure: $([ "$CONFIG_IS_MONOREPO" = "true" ] && echo "Monorepo" || echo "Single app")

PROJECT_NAME := $CONFIG_PROJECT_NAME
STACK := $CONFIG_STACK

# Make library configuration
MK_DIR := mk
MK_REPO := https://github.com/${GITHUB_REPO}.git
MK_BRANCH := ${GITHUB_BRANCH}

EOF

    # Add stack-specific configurations
    add_stack_configs
    
    cat >> Makefile << EOF
# Docker configuration
DOCKER ?= $CONFIG_USE_DOCKER

# Include make library files
INCLUDES := \$(MK_DIR)/common.mk \$(MK_DIR)/init.mk \$(addprefix \$(MK_DIR)/,\$(addsuffix .mk,\$(STACK)))

# Bootstrap init rule (replaced by init.mk after first run)
.PHONY: init
init: ## Initialize or update the make library
	@echo "==> Initializing make library..."
	@git sparse-checkout disable 2>/dev/null || true
	@if [ ! -d \$(MK_DIR) ]; then \\
		git clone --no-checkout --depth 1 --branch \$(MK_BRANCH) --filter=blob:none \$(MK_REPO) \$(MK_DIR) && \\
		cd \$(MK_DIR) && \\
		git sparse-checkout init --no-cone && \\
		echo "make/common.mk" > .git/info/sparse-checkout && \\
		echo "make/init.mk" >> .git/info/sparse-checkout && \\
		for file in \$(STACK); do echo "make/\$\${file}.mk" >> .git/info/sparse-checkout; done && \\
		git checkout \$(MK_BRANCH) && \\
		cd make && cp *.mk ../. && cd .. && \\
		rm -rf .git make docker lib tests bootstrap.sh README.md && \\
		echo "==> Make library initialized"; \\
	else \\
		echo "==> Updating make library..." && \\
		rm -rf \$(MK_DIR) && make init; \\
	fi

-include \$(INCLUDES)
EOF
}

# Add all stack-specific configurations
add_stack_configs() {
    [[ "$CONFIG_STACK" == *"vue"* ]] && cat >> Makefile << EOF
# Vue configuration
VUE_DIR := $CONFIG_CLIENT_DIR
JS_PKG_MANAGER := $CONFIG_JS_PKG
VUE_DOCKERFILE := docker/vue/Dockerfile

EOF

    [[ "$CONFIG_STACK" == *"nuxt"* ]] && cat >> Makefile << EOF
# Nuxt configuration
NUXT_DIR := $CONFIG_CLIENT_DIR
JS_PKG_MANAGER := $CONFIG_JS_PKG
NUXT_DOCKERFILE := docker/nuxt/Dockerfile

EOF

    [[ "$CONFIG_STACK" == *"fastapi"* ]] && cat >> Makefile << EOF
# FastAPI configuration
FASTAPI_DIR := $CONFIG_SERVER_DIR
PY_PKG_MANAGER := $CONFIG_PY_PKG
FASTAPI_DOCKERFILE := docker/fastapi/Dockerfile

EOF

    [[ "$CONFIG_STACK" == *"husky"* ]] && cat >> Makefile << EOF
# Husky configuration
HUSKY_DIR := $CONFIG_CLIENT_DIR

EOF
}