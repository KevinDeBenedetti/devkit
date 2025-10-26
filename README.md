```sh
project-installer/
├── .github/
│   └── workflows/
│       └── release.yml           # Automatisation build + publish
│
├── src/                          # CODE RUST
│   ├── main.rs                   # Point d'entrée
│   ├── cli/
│   │   ├── mod.rs
│   │   └── commands.rs           # Commandes CLI
│   └── ui/
│       ├── mod.rs
│       └── installer.rs          # Interface ratatui (optionnel pour v1)
│
├── scripts/                      # SCRIPTS NPM
│   └── install-binary.js         # Télécharge le binaire au postinstall
│
├── test/                         # TESTS
│   └── test-local.js             # Test de l'API Node.js
│
├── examples/                     # EXEMPLES D'USAGE
│   ├── api-usage.js
│   └── cli-usage.sh
│
├── .gitignore
├── .npmignore
├── Cargo.toml                    # Config Rust
├── Cargo.lock
├── package.json                  # Config npm
├── index.js                      # API Node.js
├── index.d.ts                    # Types TypeScript
├── cli.js                        # Entry point CLI
├── LICENSE
└── README.md
```