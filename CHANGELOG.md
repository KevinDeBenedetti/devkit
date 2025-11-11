# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2](https://github.com/KevinDeBenedetti/devkit/compare/v0.1.1...v0.1.2) (2025-11-11)


### Bug Fixes

* remove package-name from release-please configuration and update changelog sections ([7c77375](https://github.com/KevinDeBenedetti/devkit/commit/7c77375ccaca212063c9f171c073133a2b7c3fbe))

## [0.1.1](https://github.com/KevinDeBenedetti/devkit/compare/v0.1.0...v0.1.1) (2025-11-10)


### Bug Fixes

* update permissions and improve job matrix clarity in build-binaries.yml ([d11a1ba](https://github.com/KevinDeBenedetti/devkit/commit/d11a1ba273ee65b70bdeb9c4f61445b9763a3966))

## 0.1.0 (2025-11-10)


### Features

* add a configuration release-plz ([da8805b](https://github.com/KevinDeBenedetti/devkit/commit/da8805bbd1301d316c785875dd9d83457ca9e032))
* add a workflow release-plz & delete old workflow release ([2493b5c](https://github.com/KevinDeBenedetti/devkit/commit/2493b5c20bc0c4505eaa4001991b1a88c7d6ddd7))
* add an install script ([42c3923](https://github.com/KevinDeBenedetti/devkit/commit/42c392385f500c0e95b9f0ea2049cd656913ea27))
* add bootstrap script and modules for prerequisites validation, file generation, and installation ([68a28c9](https://github.com/KevinDeBenedetti/devkit/commit/68a28c91d9f3a56e01da80e7530b6edaea16001c))
* add branch option to bootstrap script and improve Makefile generation ([420fe88](https://github.com/KevinDeBenedetti/devkit/commit/420fe88cb23f42ed7f33d64ab9647ece1dbea502))
* add common config ([735d0bc](https://github.com/KevinDeBenedetti/devkit/commit/735d0bc639e283c3813ed0493c4142be723972ec))
* add dependabot for cargo et github-actions ([4d9b66f](https://github.com/KevinDeBenedetti/devkit/commit/4d9b66fc36ca330072f14fbe2e5b9dc7fde01257))
* add development targets for common and Nuxt makefiles ([aa138f6](https://github.com/KevinDeBenedetti/devkit/commit/aa138f61f6eeed5fbec461960d72ed5cd9273c13))
* add docker templates vue & fastapi ([1ceccff](https://github.com/KevinDeBenedetti/devkit/commit/1ceccff96561feb9aa1f149a24b0d23568136f04))
* add fallback function for project structure in the bootstrap script ([047b305](https://github.com/KevinDeBenedetti/devkit/commit/047b30547d553036293b1b565ad83dc65517724a))
* add fastapi.mk ([2bdcdfe](https://github.com/KevinDeBenedetti/devkit/commit/2bdcdfee0ab023bb10146c5cd6db816ffea5bf57))
* add gitignore & update readme ([46b2725](https://github.com/KevinDeBenedetti/devkit/commit/46b2725c11c46d15809a17a9900d473bb066f432))
* add husky.mk ([eb28427](https://github.com/KevinDeBenedetti/devkit/commit/eb2842733302482bbbc373436efe5b0fe796a323))
* add init rules & improve sparse-checkout in Makefile ([906ed78](https://github.com/KevinDeBenedetti/devkit/commit/906ed784cb5e87e1cacb559c83bd0e9eff9d21d9))
* add interactive menu ([2ddd6b4](https://github.com/KevinDeBenedetti/devkit/commit/2ddd6b48208988af3736b2c7461d017409a12c50))
* add interactive prompts for project structure, stack selection, and package managers ([e897637](https://github.com/KevinDeBenedetti/devkit/commit/e8976377b19c2d12b7bc7ccbb4930394ad1b643f))
* add Makefile and enhance common/nuxt makefiles for improved project setup ([c4867f0](https://github.com/KevinDeBenedetti/devkit/commit/c4867f05ad39c80a4efa97c3210234ad07650dc2))
* Add project installer with Docker, Makefile, and template support ([1cdcf4e](https://github.com/KevinDeBenedetti/devkit/commit/1cdcf4eda9720d1eb91f3d06d81a7fda2e5eb54d))
* add README instructions ([5b7cbad](https://github.com/KevinDeBenedetti/devkit/commit/5b7cbad413573730b835771458ce3be55451aba5))
* add release plz config ([26aaec8](https://github.com/KevinDeBenedetti/devkit/commit/26aaec8e59aa6093f03a5ab69f01c6d9229f4f39))
* add release-please ([84fc216](https://github.com/KevinDeBenedetti/devkit/commit/84fc216a191d1b8a4b24959740d7b05000ef5e71))
* add release-plz config ([1f9d904](https://github.com/KevinDeBenedetti/devkit/commit/1f9d9048e8e1b7a7c3d46e752d189fae33d5702d))
* add target make for nuxt ([de751e2](https://github.com/KevinDeBenedetti/devkit/commit/de751e21973d75c811fcb3151ab152c432330e79))
* add tests for Makefile generation et refactor config scripts ([88565e3](https://github.com/KevinDeBenedetti/devkit/commit/88565e374ed1b8534ffc08d26f88553b20fb7c2e))
* add vue mk ([3cbf271](https://github.com/KevinDeBenedetti/devkit/commit/3cbf271d44955e0374959039f70f7c003319ce17))
* add workflows release & builds ([63bcba3](https://github.com/KevinDeBenedetti/devkit/commit/63bcba37594556b2c8002d561a45207549a5b78d))
* **cli:** Add path options for Init and Config commands ([59f925d](https://github.com/KevinDeBenedetti/devkit/commit/59f925d842b476a0557dbac869166b197465e93a))
* **cli:** Implement CLI structure with commands for project configuration ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **config:** Add FastAPI stack support and update configuration files ([59f925d](https://github.com/KevinDeBenedetti/devkit/commit/59f925d842b476a0557dbac869166b197465e93a))
* **config:** Add stack configuration management and file generation ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* delete Makefile ([242866b](https://github.com/KevinDeBenedetti/devkit/commit/242866b0e431ba8c7a42d7c56c167bc86cdb9442))
* **docker:** Add Docker files for building and deploying the Nuxt application ([7f67686](https://github.com/KevinDeBenedetti/devkit/commit/7f676860a4c2825b9d710e3e7dd0e4b654f1b204))
* enhance bootstrap script to support remote execution and file downloading ([1c92f24](https://github.com/KevinDeBenedetti/devkit/commit/1c92f240f3e40589667bf33ca2183e91a0cf2a25))
* format helper response ([33eece0](https://github.com/KevinDeBenedetti/devkit/commit/33eece0e5fbf1e144986fb207ee14030c15baa55))
* improve Makefile documentation ([3d1fe90](https://github.com/KevinDeBenedetti/devkit/commit/3d1fe906fc64b5ea08c7bd5be0bf25bd46943f72))
* integrate gum for enhanced UI in prompts and bootstrap script ([06e7c19](https://github.com/KevinDeBenedetti/devkit/commit/06e7c196b0d6edb49d85b72a55b24e24300939ef))
* **main:** Integrate CLI commands and interactive setup for project configuration ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* remove unused phony targets from makefiles ([4b99764](https://github.com/KevinDeBenedetti/devkit/commit/4b997642828e8633f5fa4e10131db576da110557))
* **templates:** Add common makefile with help and validation commands ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **templates:** Add Dockerignore and Dockerfile templates for FastAPI ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **templates:** Add Husky makefile for git hooks setup ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **templates:** Add Vue Dockerignore and Dockerfile templates ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **templates:** Create FastAPI makefile with common tasks ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **templates:** Create Nuxt makefile with development tasks ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **templates:** Implement initialization makefile for project setup ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **templates:** Implement Vue makefile with common tasks ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **ui:** Develop interactive terminal UI for project stack selection ([e3cdcbe](https://github.com/KevinDeBenedetti/devkit/commit/e3cdcbe6dba4d42880a2e2b5d556ede0e32d5024))
* **ui:** Improve interactive UI with path handling and confirmation ([59f925d](https://github.com/KevinDeBenedetti/devkit/commit/59f925d842b476a0557dbac869166b197465e93a))
* Update .gitignore to include target and examples directories ([b1bd6c9](https://github.com/KevinDeBenedetti/devkit/commit/b1bd6c962586cd6d9e8a123d61d84637b111fae3))
* update workflows for release process and add CD configuration ([78ed490](https://github.com/KevinDeBenedetti/devkit/commit/78ed4908508b3bf165286b2c8c84a39b9bcffe80))


### Bug Fixes

* add /dev/tty for users entries ([e4a70aa](https://github.com/KevinDeBenedetti/devkit/commit/e4a70aa9d78a23537b4019db62032a52cf5147b3))
* add git_tag_name for devkit package in release-plz configuration ([bda0ac1](https://github.com/KevinDeBenedetti/devkit/commit/bda0ac10d2f2177e23b99e2770d46e63f226e0e2))
* add missing semicolons and improve control flow in vue.mk ([69cd31a](https://github.com/KevinDeBenedetti/devkit/commit/69cd31a5932deaccaabdc97901f6d56b9c06fd43))
* add missing semicolons and improve lint command handling in fastapi.mk ([15b9d96](https://github.com/KevinDeBenedetti/devkit/commit/15b9d96d10d523267a4d44711bded438fbcd0471))
* add registry entry for devkit package in release-plz configuration ([66a2d55](https://github.com/KevinDeBenedetti/devkit/commit/66a2d55801e2f4fbd4eef4539ac4e680dd3667f7))
* cd ([7be36c1](https://github.com/KevinDeBenedetti/devkit/commit/7be36c13f75b93f8ed17751671f478bd45b99c55))
* delete release-plz.toml ([107bc48](https://github.com/KevinDeBenedetti/devkit/commit/107bc482cefd7c1d7f460c11ea80a2174d9759d2))
* downgrade devkit version to 0.1.0 ([3a7791f](https://github.com/KevinDeBenedetti/devkit/commit/3a7791f6194aad3f296fedb6f7f7061bc5e13fb3))
* ensure key reading from terminal device in selection functions ([6b90b72](https://github.com/KevinDeBenedetti/devkit/commit/6b90b721903bc77925d09d58fea897743fa5daf0))
* impove build binaries workflow ([ed90938](https://github.com/KevinDeBenedetti/devkit/commit/ed9093812a5133e9f13f3f8d1290e69f08ba9bc8))
* improve input handling for project name prompt ([bb11b62](https://github.com/KevinDeBenedetti/devkit/commit/bb11b62521c5e7bbc6df102a3e1e18a1e6da4c91))
* release-plz config ([6222432](https://github.com/KevinDeBenedetti/devkit/commit/62224329b6cf51b907b597ca7cb045b8a89de353))
* remove changelog_include configuration from release-plz ([511e5af](https://github.com/KevinDeBenedetti/devkit/commit/511e5af95e1277276efa8cb39db9e7d3ac1aa84d))
* remove persist-credentials option from checkout step ([c11bc56](https://github.com/KevinDeBenedetti/devkit/commit/c11bc5675982027a6b917b7be534a90b75a1f8f2))
* remove unused CARGO_REGISTRY_TOKEN from release-plz workflow ([64b7fff](https://github.com/KevinDeBenedetti/devkit/commit/64b7fff600ba126e94c631430fb181f67b6a2175))
* remove unused CD workflow and clean up release-plz permissions ([4cdc4b7](https://github.com/KevinDeBenedetti/devkit/commit/4cdc4b7c559f23a6530f6e55c4fcb24d2eec3c6d))
* Update comments from French to English for consistency and optimize release profile settings ([429177d](https://github.com/KevinDeBenedetti/devkit/commit/429177d76680b8f9a74a841e46fec9dda9304950))
* update dependencies ([6cff5de](https://github.com/KevinDeBenedetti/devkit/commit/6cff5de6161d2c38e5dc9a55179d0c571bea9cdc))
* Update French comments and documentation to English for consistency ([c2aca7b](https://github.com/KevinDeBenedetti/devkit/commit/c2aca7be8b732a3f09c1ef33f407dbb73744c110))
* Update French translations to English in various files for consistency ([42cd9d4](https://github.com/KevinDeBenedetti/devkit/commit/42cd9d4295f3820c5c29d68b163fbbfb8ddcc45c))
* update install.sh ([d3ecfdb](https://github.com/KevinDeBenedetti/devkit/commit/d3ecfdb80235590c6f2cdf2b1724be3034a8dcb9))
* update install.sh ([968e215](https://github.com/KevinDeBenedetti/devkit/commit/968e2152054831f467a0e481975bdb8dbb4cb1bb))
* update release plz workflow ([005dd35](https://github.com/KevinDeBenedetti/devkit/commit/005dd3553a373b2e5a2a54581d1d49fa2ea8306c))
* update release trigger to only respond to published events ([ec5c2a8](https://github.com/KevinDeBenedetti/devkit/commit/ec5c2a80af347659b7759540cac5f9e85b95f1a1))

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
