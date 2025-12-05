# GitHub Copilot Instructions — DevKit

## Project Context  
DevKit is a **Rust CLI tool** designed to help developers choose and scaffold a Rust project stack. It supports generating project templates, configuring dependencies, and offering best-practice recommendations for different Rust “stack” styles.

## Repository Structure  
- `src/`: core Rust source code  
- `src/cli/`: definition of CLI commands
- `src/config/`: definition of configuration management
- `src/ui/`: definition of user interface components  
- `templates/`: project templates for different stack types  
- `Cargo.toml`: project configuration and dependency manifest  
- `tests/`: unit and integration tests  

## Key Dependencies & Conventions  
- CLI parsing: likely using `clap`
- Configuration serialization: `serde` + `serde_json`
- Error handling: using crates like `anyhow` or `thiserror`  
- Rust naming conventions:  
  - `snake_case` for functions and variables
  - `PascalCase` for types and enums
- Documentation: use `///` to document public functions  

## Build, Test & Validation Workflow  
1. **Build**: run `cargo build --release` to compile the optimized binary.  
2. **Run / Use the CLI**: execute `cargo run -- <command>` to test CLI commands interactively.  
3. **Test**: run `cargo test` to execute all tests.  
4. **Lint / Check Style**: run `cargo clippy` (if available) to enforce code quality.  
5. **Pull Request Guidelines**:  
   - Create a new branch for changes.  
   - After making changes, run build + tests locally.  
   - Only submit a PR if build and tests pass successfully.  
6. **Manual Validation**: For new CLI commands, test both normal and error cases, and ensure behavior is correct.  

## Best Practices for Copilot Suggestions  
- Favor **idiomatic Rust**: use `Result<T, E>`, the `?` operator, `match`, etc.  
- When adding CLI options or new commands, also generate example usage or tests.  
- Respect project naming conventions and modular structure.  
- When creating new templates in `templates/`, ensure they are consistent with existing templates and well structured.

## Guidance for the Agent
- Trust these instructions as the primary guide: only search or infer if something is missing or unclear.  
- Avoid proposing changes that break the build or tests — always validate generated code against the build / test process.  
- If uncertain, write “safe” code (with error handling) that can be refined later, rather than overly optimised untested code.

## Validation of Instructions
- When interacting with Copilot Chat in this repo, verify that `.github/copilot-instructions.md` appears in the “References” of the prompt. :contentReference[oaicite:0]{index=0}  
- If Copilot produces suggestions that don’t respect these rules, update this file to clarify conventions or constraints.
