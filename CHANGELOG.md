# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1](https://github.com/KevinDeBenedetti/devkit/compare/v0.1.0...v0.1.1) - 2025-11-09

### Added

- add a configuration release-plz
- update workflows for release process and add CD configuration
- add README instructions
- add release-plz config
- add a workflow release-plz & delete old workflow release
- add an install script
- add dependabot for cargo et github-actions
- add workflows release & builds
- add release plz config
- *(docker)* Add Docker files for building and deploying the Nuxt application
- Update .gitignore to include target and examples directories
- *(cli)* Add path options for Init and Config commands
- *(cli)* Implement CLI structure with commands for project configuration
- Add project installer with Docker, Makefile, and template support
- integrate gum for enhanced UI in prompts and bootstrap script
- add fallback function for project structure in the bootstrap script
- add interactive prompts for project structure, stack selection, and package managers
- add branch option to bootstrap script and improve Makefile generation
- add interactive menu
- add init rules & improve sparse-checkout in Makefile
- add tests for Makefile generation et refactor config scripts
- enhance bootstrap script to support remote execution and file downloading
- add bootstrap script and modules for prerequisites validation, file generation, and installation
- add docker templates vue & fastapi
- add fastapi.mk
- add husky.mk
- add vue mk
- improve Makefile documentation
- remove unused phony targets from makefiles
- delete Makefile
- add gitignore & update readme
- add Makefile and enhance common/nuxt makefiles for improved project setup
- add development targets for common and Nuxt makefiles
- format helper response
- add target make for nuxt
- add common config

### Fixed

- downgrade devkit version to 0.1.0
- update dependencies
- remove persist-credentials option from checkout step
- cd
- remove unused CD workflow and clean up release-plz permissions
- impove build binaries workflow
- remove changelog_include configuration from release-plz
- release-plz config
- remove unused CARGO_REGISTRY_TOKEN from release-plz workflow
- update install.sh
- update install.sh
- Update comments from French to English for consistency and optimize release profile settings
- Update French comments and documentation to English for consistency
- Update French translations to English in various files for consistency
- improve input handling for project name prompt
- ensure key reading from terminal device in selection functions
- add /dev/tty for users entries
- add missing semicolons and improve control flow in vue.mk
- add missing semicolons and improve lint command handling in fastapi.mk

### Other

- comment newest config
- simplify release-plz workflow and remove changelog file
- clean cd
- release v0.1.1
- *(deps)* bump actions/checkout from 4 to 5
- *(deps)* bump softprops/action-gh-release from 1 to 2
- clean README
- update example usage URL in bootstrap script
- simplify selection logic in interactive menus
- delete obsolete methods
- bootstrap & handle errors
- delete tests yet
- simplify configuration generation in main function
- redirect messages to stderr in prompts.sh
- improve messages in prompts.sh
- reorganiser la logique de détection d'exécution locale ou distante dans le script bootstrap
- make file to handle other automation
- remove project name references and simplify echo statements in common.mk
- simplify nuxt config & readme
- update readme
- first commit
