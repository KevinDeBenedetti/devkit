# make-library

Make-library is a collection of reusable makefiles to initialize, configure, and automate projects (Nuxt, FastAPI, Python, etc.). It provides standard targets (init, build, test), configurable variables, and a sparse-checkout/submodule mechanism to include only the files needed by the project.

## Dependency manager configuration

### Initial Setup

Create a `Makefile` in the root of your project and include the relevant makefiles based on your stack.

Example Makefile snippet:

```makefile
# Make-library configuration
MK_DIR := mk
MK_REPO := https://github.com/KevinDeBenedetti/make-library.git
MK_BRANCH := main

# Project-specific variables
PROJECT_NAME := my-project

# Stack to use
STACK := nuxt fastapi # or "vue", "fastapi", "python", etc.

# Paths to include makefiles
INCLUDES := common.mk

# Makefiles for each stack
MK_FILES := $(addsuffix .mk,$(STACK))
SPARSE_CHECKOUT_FILES := common.mk $(MK_FILES)

# Target to initialize or update the make-library
.PHONY: init
init:
	@if [ ! -d $(MK_DIR) ]; then \
		echo "==> Cloning make-library with sparse checkout..."; \
		git clone --no-checkout --depth 1 --branch $(MK_BRANCH) --filter=blob:none $(MK_REPO) $(MK_DIR); \
		cd $(MK_DIR) && \
		git sparse-checkout init --no-cone && \
		echo "common.mk" > .git/info/sparse-checkout && \
		$(foreach file,$(MK_FILES),echo "$(file)" >> .git/info/sparse-checkout &&) true && \
		git checkout $(MK_BRANCH); \
	else \
		echo "==> Updating make-library..."; \
		cd $(MK_DIR) && \
		git sparse-checkout init --no-cone && \
		echo "common.mk" > .git/info/sparse-checkout && \
		$(foreach file,$(MK_FILES),echo "$(file)" >> .git/info/sparse-checkout &&) true && \
		git fetch origin && \
		git reset --hard origin/$(MK_BRANCH); \
	fi

# Include the makefiles
INCLUDES := $(MK_DIR)/common.mk $(addprefix $(MK_DIR)/,$(MK_FILES))
-include $(INCLUDES)

```

---
### Nuxt

Specific variables for Nuxt projects.

```makefile
# Nuxt-specific variables
JS_PKG_MANAGER := npm
NUXT_DIR := .
```

#### JavaScript/TypeScript
- `npm` (default)
- `yarn`
- `pnpm`
- `bun`
