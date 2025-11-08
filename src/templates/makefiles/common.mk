.PHONY: help validate dev build test lint clean

help: ## Show available commands
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":"; prev=""} \
		{ \
			file = $$1; \
			gsub(/^.*\//, "", file); \
			if (file != prev && prev != "") print ""; \
			prev = file; \
			sub(/^[^:]*:/, ""); \
			split($$0, arr, ":.*?## "); \
			printf "  \033[36m%-25s\033[0m %s\n", arr[1], arr[2]; \
		}'

validate: ## Validate environment
	@echo "Validating environment..."
	@echo "STACK: $(STACK)"

dev: validate ## Start development server
	@echo "Starting development server with stack $(STACK)"

build: validate ## Build the project
	@echo "Building project with stack $(STACK)"

test: validate ## Run tests
	@echo "Running tests for $(STACK)"

lint: validate ## Run linting
	@echo "Running linting for $(STACK)"

clean: validate ## Clean artifacts
	@echo "Cleaning artifacts for $(STACK)"
