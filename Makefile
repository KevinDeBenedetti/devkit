# Project-specific variables
PROJECT_NAME := my-project
STACK := nuxt     # or "vue", "fastapi", "python", etc.

# Configurable package managers
JS_PKG_MANAGER := pnpm    # or "yarn", "pnpm", "bun"

# Default paths
NUXT_DIR := .

# Files to include
INCLUDES := common.mk

# Conditional inclusion based on STACK
ifeq ($(findstring nuxt,$(STACK)),nuxt)
  INCLUDES += nuxt.mk
endif

# Check that files exist before including them
$(foreach file,$(INCLUDES),$(if $(wildcard $(file)),,$(error File $(file) does not exist)))

# Include files
include $(INCLUDES)
