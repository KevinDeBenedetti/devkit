#!/bin/bash
# Test script to validate the refactored Makefile generation

set -e

echo "🧪 Testing Makefile Generation"
echo "================================"
echo ""

# Create a temporary test directory
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

echo "📁 Test directory: $TEST_DIR"
cd "$TEST_DIR"

# Copy the library files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
cp -r "$SCRIPT_DIR/lib" .
cp "$SCRIPT_DIR/bootstrap.sh" .

# Source the necessary modules
source lib/ui.sh
source lib/validator.sh
source lib/generator.sh

echo ""
echo "✅ Test 1: Generate config for monorepo with Vue + FastAPI"
echo "-----------------------------------------------------------"

# Test configuration generation
generate_config "test-project" "true" "vue fastapi husky" "pnpm" "uv" "true"

echo "PROJECT_NAME: $CONFIG_PROJECT_NAME"
echo "IS_MONOREPO: $CONFIG_IS_MONOREPO"
echo "STACK: $CONFIG_STACK"
echo "CLIENT_DIR: $CONFIG_CLIENT_DIR"
echo "SERVER_DIR: $CONFIG_SERVER_DIR"
echo "JS_PKG: $CONFIG_JS_PKG"
echo "PY_PKG: $CONFIG_PY_PKG"
echo "DOCKER: $CONFIG_USE_DOCKER"

# Generate Makefile
echo ""
echo "📝 Generating Makefile..."
generate_makefile

# Verify Makefile was created
if [ ! -f Makefile ]; then
    echo "❌ ERROR: Makefile was not created!"
    exit 1
fi

echo ""
echo "✅ Makefile generated successfully!"
echo ""
echo "📄 Generated Makefile content:"
echo "================================"
cat Makefile
echo "================================"

# Check key components
echo ""
echo "🔍 Validating Makefile content..."

if ! grep -q "PROJECT_NAME := test-project" Makefile; then
    echo "❌ ERROR: PROJECT_NAME not found!"
    exit 1
fi
echo "  ✓ PROJECT_NAME is set"

if ! grep -q "STACK := vue fastapi husky" Makefile; then
    echo "❌ ERROR: STACK not correct!"
    exit 1
fi
echo "  ✓ STACK is set"

if ! grep -q "VUE_DIR := ./apps/client" Makefile; then
    echo "❌ ERROR: VUE_DIR not correct!"
    exit 1
fi
echo "  ✓ VUE_DIR is set correctly for monorepo"

if ! grep -q "FASTAPI_DIR := ./apps/server" Makefile; then
    echo "❌ ERROR: FASTAPI_DIR not correct!"
    exit 1
fi
echo "  ✓ FASTAPI_DIR is set correctly for monorepo"

if ! grep -q "JS_PKG_MANAGER := pnpm" Makefile; then
    echo "❌ ERROR: JS_PKG_MANAGER not found!"
    exit 1
fi
echo "  ✓ JS_PKG_MANAGER is set"

if ! grep -q "PY_PKG_MANAGER := uv" Makefile; then
    echo "❌ ERROR: PY_PKG_MANAGER not found!"
    exit 1
fi
echo "  ✓ PY_PKG_MANAGER is set"

if ! grep -q "DOCKER ?= true" Makefile; then
    echo "❌ ERROR: DOCKER not found!"
    exit 1
fi
echo "  ✓ DOCKER is set"

if ! grep -q '\$(MK_DIR)/common.mk' Makefile; then
    echo "❌ ERROR: common.mk include not found!"
    exit 1
fi
echo "  ✓ common.mk is included"

if ! grep -q '\$(MK_DIR)/init.mk' Makefile; then
    echo "❌ ERROR: init.mk include not found!"
    exit 1
fi
echo "  ✓ init.mk is included"

# Test 2: Single app structure
echo ""
echo "✅ Test 2: Generate config for single app with Nuxt"
echo "---------------------------------------------------"

generate_config "single-app" "false" "nuxt" "npm" "" "false"

echo "CLIENT_DIR: $CONFIG_CLIENT_DIR (should be .)"
echo "SERVER_DIR: $CONFIG_SERVER_DIR (should be .)"

if [ "$CONFIG_CLIENT_DIR" != "." ]; then
    echo "❌ ERROR: Single app should use . as CLIENT_DIR!"
    exit 1
fi
echo "  ✓ Single app structure uses correct paths"

echo ""
echo "🎉 All tests passed!"
echo ""
echo "📊 Summary:"
echo "  - Configuration generation: ✅"
echo "  - Makefile generation: ✅"
echo "  - Variable settings: ✅"
echo "  - File includes: ✅"
echo "  - Monorepo structure: ✅"
echo "  - Single app structure: ✅"
