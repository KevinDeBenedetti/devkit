.PHONY: init dockerfiles

# Variables for make library management
MK_DIR ?= mk
MK_REPO ?= https://github.com/KevinDeBenedetti/devkit.git
MK_BRANCH ?= main
MK_FILES := $(addsuffix .mk,$(STACK))
SPARSE_CHECKOUT_FILES := common.mk init.mk $(MK_FILES)

# Extract GitHub org and repo name from MK_REPO URL
MK_GITHUB_PATH := $(shell echo $(MK_REPO) | sed 's/https:\/\/github.com\///' | sed 's/\.git//')
MK_RAW_BASE_URL := https://raw.githubusercontent.com/$(MK_GITHUB_PATH)/$(MK_BRANCH)

init: ## Initialize or update the make library
	@echo "==> Checking git sparse-checkout configuration..."
	@git sparse-checkout disable 2>/dev/null || true
	@if [ ! -d $(MK_DIR) ]; then \
		echo "==> Cloning make-library with sparse checkout..."; \
		git clone --no-checkout --depth 1 --branch $(MK_BRANCH) --filter=blob:none $(MK_REPO) $(MK_DIR); \
		cd $(MK_DIR) && \
		git sparse-checkout init --no-cone && \
		echo "make/common.mk" > .git/info/sparse-checkout && \
		echo "make/init.mk" >> .git/info/sparse-checkout && \
		$(foreach file,$(MK_FILES),echo "make/$(file)" >> .git/info/sparse-checkout &&) true && \
		git checkout $(MK_BRANCH) && \
		cd make && \
		cp *.mk ../. && \
		cd .. && \
		rm -rf .git make docker lib tests bootstrap.sh README.md; \
		echo "==> Make library initialized successfully"; \
	else \
		echo "==> Updating make-library..."; \
		rm -rf $(MK_DIR); \
		git clone --no-checkout --depth 1 --branch $(MK_BRANCH) --filter=blob:none $(MK_REPO) $(MK_DIR); \
		cd $(MK_DIR) && \
		git sparse-checkout init --no-cone && \
		echo "make/common.mk" > .git/info/sparse-checkout && \
		echo "make/init.mk" >> .git/info/sparse-checkout && \
		$(foreach file,$(MK_FILES),echo "make/$(file)" >> .git/info/sparse-checkout &&) true && \
		git checkout $(MK_BRANCH) && \
		cd make && \
		cp *.mk ../. && \
		cd .. && \
		rm -rf .git make docker lib tests bootstrap.sh README.md; \
		echo "==> Make library updated successfully"; \
	fi

dockerfiles: ## Download Dockerfiles from GitHub
	@echo "==> Downloading Dockerfiles from branch $(MK_BRANCH)..."
	@if [ -n "$(VUE_DOCKERFILE)" ]; then \
		echo "  -> Downloading Vue Dockerfile to $(VUE_DIR)/Dockerfile"; \
		mkdir -p $(VUE_DIR); \
		curl -fsSL $(MK_RAW_BASE_URL)/$(VUE_DOCKERFILE) -o $(VUE_DIR)/Dockerfile; \
	fi
	@if [ -n "$(NUXT_DOCKERFILE)" ]; then \
		echo "  -> Downloading Nuxt Dockerfile to $(NUXT_DIR)/Dockerfile"; \
		mkdir -p $(NUXT_DIR); \
		curl -fsSL $(MK_RAW_BASE_URL)/$(NUXT_DOCKERFILE) -o $(NUXT_DIR)/Dockerfile; \
	fi
	@if [ -n "$(FASTAPI_DOCKERFILE)" ]; then \
		echo "  -> Downloading FastAPI Dockerfile to $(FASTAPI_DIR)/Dockerfile"; \
		mkdir -p $(FASTAPI_DIR); \
		curl -fsSL $(MK_RAW_BASE_URL)/$(FASTAPI_DOCKERFILE) -o $(FASTAPI_DIR)/Dockerfile; \
	fi
	@echo "==> Dockerfiles downloaded successfully"
