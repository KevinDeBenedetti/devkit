```sh
project-installer/
├── .github/
│   └── workflows/
│       └── release.yml           # Automate build + publish
│
├── src/                          # RUST CODE
│   ├── main.rs                   # Entry point
│   ├── cli/
│   │   ├── mod.rs
│   │   └── commands.rs           # CLI commands
│   └── ui/
│       ├── mod.rs
│       └── installer.rs          # ratatui interface (optional for v1)
│
├── scripts/                      # NPM SCRIPTS
│   └── install-binary.js         # Download binary on postinstall
│
├── test/                         # TESTS
│   └── test-local.js             # Node.js API test
│
├── examples/                     # USAGE EXAMPLES
│   ├── api-usage.js
│   └── cli-usage.sh
│
├── .gitignore
├── .npmignore
├── Cargo.toml                    # Rust config
├── Cargo.lock
├── package.json                  # npm config
├── index.js                      # Node.js API
├── index.d.ts                    # TypeScript types
├── cli.js                        # CLI entry point
├── LICENSE
└── README.md
```