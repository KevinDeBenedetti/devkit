# Makefile - common commands for a Rust project

CARGO ?= cargo
FEATURES ?=
ARGS ?=

all: build

build:
	$(CARGO) build $(if $(strip $(FEATURES)),--features $(FEATURES),)

release:
	$(CARGO) build --release $(if $(strip $(FEATURES)),--features $(FEATURES),)

run:
	$(CARGO) run $(if $(strip $(FEATURES)),--features $(FEATURES),) -- $(ARGS)

run-release:
	$(CARGO) run --release $(if $(strip $(FEATURES)),--features $(FEATURES),) -- $(ARGS)

check:
	$(CARGO) check $(if $(strip $(FEATURES)),--features $(FEATURES),)

test:
	$(CARGO) test $(if $(strip $(FEATURES)),--features $(FEATURES),)

fmt:
	$(CARGO) fmt

fmt-check:
	$(CARGO) fmt -- --check

clippy:
	$(CARGO) clippy --all-targets --all-features -- -D warnings

clippy-warn:
	$(CARGO) clippy --all-targets --all-features

doc:
	$(CARGO) doc --no-deps

bench:
	$(CARGO) bench

install:
	$(CARGO) install --path .

package:
	$(CARGO) package

publish:
	$(CARGO) publish

update:
	$(CARGO) update

clean:
	$(CARGO) clean

ci: fmt-check clippy check test

help:
	@printf "Usage: make <target>\n\nTargets:\n  build         Build (default)\n  release       Build release\n  run           Run (pass ARGS=\"...\")\n  run-release   Run release build\n  check         cargo check\n  test          Run tests\n  fmt           Format code\n  fmt-check     Check formatting\n  clippy        Lint and treat warnings as errors\n  doc           Build docs\n  bench         Run benchmarks\n  install       cargo install --path .\n  package       cargo package\n  publish       cargo publish\n  update        cargo update\n  clean         cargo clean\n  ci            fmt-check, clippy, check, test\n\nOptional variables:\n  FEATURES=\"feat1,feat2\"  Build features\n  ARGS=\"...\"              Arguments forwarded to the binary\n"

.PHONY: all help build release run run-release check test fmt fmt-check clippy clippy-warn doc bench install package publish update clean ci