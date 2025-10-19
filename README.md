# make-library

## Dependency manager configuration

### Add to a project

Create a `Makefile` in the root of your project and include the relevant makefiles based on your stack.

Example Makefile snippet:

```makefile
# Project-specific variables
PROJECT_NAME := my-project

# Stack to use
STACK := nuxt-fastapi # or "vue", "fastapi", "python", etc.

# Paths to include makefiles
INCLUDES := common.mk

# Check that files exist before including them
$(foreach file,$(INCLUDES),$(if $(wildcard $(file)),,$(error File $(file) does not exist)))

# Include files
include $(INCLUDES)
```

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
