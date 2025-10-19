# Default variables if not defined
NUXT_DIR ?= .

validate-nuxt: ## Validate Nuxt environment
	@echo "Validating Nuxt environment..."
	@echo "JS_PKG_MANAGER: $(JS_PKG_MANAGER)"
	@which $(JS_PKG_MANAGER) > /dev/null || (echo "Error: $(JS_PKG_MANAGER) is not installed" && exit 1)
	@echo "✓ Nuxt environment valid"

check-nuxt-dir: ## Check that the Nuxt directory exists
	@if [ ! -d "$(NUXT_DIR)" ]; then \
		echo "Error: directory $(NUXT_DIR) does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "$(NUXT_DIR)/package.json" ]; then \
		echo "Warning: No package.json found in $(NUXT_DIR)"; \
	fi

dev-nuxt: check-nuxt-dir ## Start Nuxt development server
	@echo "Starting Nuxt development server in $(NUXT_DIR) with $(JS_PKG_MANAGER)"
	cd $(NUXT_DIR) && $(JS_PKG_MANAGER) install && $(JS_PKG_MANAGER) run dev

build-nuxt: check-nuxt-dir ## Build Nuxt application
	@echo "Building Nuxt in $(NUXT_DIR) with $(JS_PKG_MANAGER)"
	cd $(NUXT_DIR) && $(JS_PKG_MANAGER) install && $(JS_PKG_MANAGER) run build

lint-nuxt: check-nuxt-dir ## Run Nuxt linting
	@echo "Linting Nuxt in $(NUXT_DIR)"
	cd $(NUXT_DIR) && $(JS_PKG_MANAGER) run lint || echo "Lint command not available"
	cd $(NUXT_DIR) && $(JS_PKG_MANAGER) run format || echo "Format command not available"

clean-nuxt: ## Clean Nuxt artifacts
	@echo "Cleaning Nuxt artifacts..."
	@find $(NUXT_DIR) -type d -name "node_modules" -prune -print -exec rm -rf {} + 2>/dev/null || true
	@find $(NUXT_DIR) -type d -name ".nuxt" -prune -print -exec rm -rf {} + 2>/dev/null || true
	@find $(NUXT_DIR) -type d -name ".output" -prune -print -exec rm -rf {} + 2>/dev/null || true
	@find $(NUXT_DIR) -type d -name "dist" -prune -print -exec rm -rf {} + 2>/dev/null || true

upgrade-nuxt: check-nuxt-dir ## Update Nuxt dependencies
	@echo "Updating Nuxt dependencies..."
	cd $(NUXT_DIR) && $(JS_PKG_MANAGER) up --latest || $(JS_PKG_MANAGER) update

# Override common targets for Nuxt
validate: validate-nuxt
dev: dev-nuxt
build: build-nuxt
lint: lint-nuxt
clean: clean-nuxt
upgrade: upgrade-nuxt