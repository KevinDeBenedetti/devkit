.PHONY: help build test lint clean validate-env

help: ## Show helper
	@echo "Project: $(PROJECT_NAME)"
	@echo "Stack: $(STACK)"
	@echo "JS package manager: $(JS_PKG_MANAGER)"
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2}'

validate-env: ## Validate environment
	@echo "Validating environment..."
	@echo "PROJECT_NAME: $(PROJECT_NAME)"
	@echo "STACK: $(STACK)"
	@echo "JS_PKG_MANAGER: $(JS_PKG_MANAGER)"
	@which $(JS_PKG_MANAGER) > /dev/null || (echo "Error: $(JS_PKG_MANAGER) is not installed" && exit 1)
	@echo "✓ Environment valid"

build: validate-env ## Build the project
	@echo "Building project $(PROJECT_NAME) with stack $(STACK)"

test: ## Run tests
	@echo "Running tests for $(PROJECT_NAME)"

lint: ## Run linting
	@echo "Running linting for $(PROJECT_NAME)"

clean: ## Clean artifacts
	@echo "Cleaning artifacts for $(PROJECT_NAME)"
