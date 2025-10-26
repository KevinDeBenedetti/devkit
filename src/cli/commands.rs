use anyhow::{Result, anyhow};
use colored::*;
use std::fs;
use std::path::Path;

pub fn init(template: &str, output: &str) -> Result<()> {
    println!("{}", "🚀 Initializing project...".green().bold());
    println!("   Template: {}", template.cyan());
    println!("   Output:   {}", output.cyan());
    
    // Vérifier si le template existe
    let available_templates = vec!["rust-cli", "rust-api", "node-api", "python-app"];
    
    if !available_templates.contains(&template) {
        return Err(anyhow!(
            "Unknown template '{}'. Use 'installer list' to see available templates.",
            template
        ));
    }
    
    // Créer le répertoire
    let output_path = Path::new(output);
    if !output_path.exists() {
        fs::create_dir_all(output_path)?;
    }
    
    // Créer des fichiers de base selon le template
    match template {
        "rust-cli" => create_rust_cli_template(output_path)?,
        "rust-api" => create_rust_api_template(output_path)?,
        "node-api" => create_node_api_template(output_path)?,
        "python-app" => create_python_app_template(output_path)?,
        _ => {}
    }
    
    println!("\n{}", "✅ Project initialized successfully!".green().bold());
    println!("\n{}", "Next steps:".yellow());
    println!("  cd {}", output);
    println!("  installer docker --compose");
    println!("  installer makefile");
    
    Ok(())
}

pub fn setup_docker(compose: bool) -> Result<()> {
    println!("{}", "🐳 Setting up Docker...".green().bold());
    
    // Créer Dockerfile
    let dockerfile_content = r#"FROM rust:1.75 as builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim
COPY --from=builder /app/target/release/app /usr/local/bin/app
CMD ["app"]
"#;
    
    fs::write("Dockerfile", dockerfile_content)?;
    println!("   {} Dockerfile", "✓".green());
    
    // Créer docker-compose.yml si demandé
    if compose {
        let compose_content = r#"version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - RUST_LOG=info
    volumes:
      - .:/app
"#;
        fs::write("docker-compose.yml", compose_content)?;
        println!("   {} docker-compose.yml", "✓".green());
    }
    
    // Créer .dockerignore
    let dockerignore_content = r#"target/
node_modules/
.git/
*.log
"#;
    fs::write(".dockerignore", dockerignore_content)?;
    println!("   {} .dockerignore", "✓".green());
    
    println!("\n{}", "✅ Docker setup complete!".green().bold());
    
    if compose {
        println!("\n{}", "Start with:".yellow());
        println!("  docker-compose up");
    }
    
    Ok(())
}

pub fn setup_makefile() -> Result<()> {
    println!("{}", "📝 Setting up Makefile...".green().bold());
    
    let makefile_content = r#".PHONY: help dev build test clean docker-up docker-down

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

dev: ## Run in development mode
	cargo run

build: ## Build release
	cargo build --release

test: ## Run tests
	cargo test

clean: ## Clean build artifacts
	cargo clean
	rm -rf target/

docker-up: ## Start Docker containers
	docker-compose up -d

docker-down: ## Stop Docker containers
	docker-compose down

install: ## Install dependencies
	cargo fetch

.DEFAULT_GOAL := help
"#;
    
    fs::write("Makefile", makefile_content)?;
    
    println!("\n{}", "✅ Makefile created!".green().bold());
    println!("\n{}", "Available commands:".yellow());
    println!("  make help       - Show all commands");
    println!("  make dev        - Run in dev mode");
    println!("  make build      - Build release");
    println!("  make test       - Run tests");
    
    Ok(())
}

pub fn list_templates() -> Result<()> {
    println!("{}", "📦 Available templates:".green().bold());
    println!();
    
    let templates = vec![
        ("rust-cli", "Rust CLI application with clap"),
        ("rust-api", "Rust API with Axum/Actix"),
        ("node-api", "Node.js API with Express"),
        ("python-app", "Python application with Poetry"),
    ];
    
    for (name, desc) in templates {
        println!("  {} - {}", name.cyan().bold(), desc);
    }
    
    println!();
    println!("{}", "Usage:".yellow());
    println!("  installer init <template> <output-dir>");
    println!();
    println!("{}", "Example:".yellow());
    println!("  installer init rust-cli ./my-project");
    
    Ok(())
}

// Templates helpers
fn create_rust_cli_template(path: &Path) -> Result<()> {
    let cargo_toml = r#"[package]
name = "my-cli"
version = "0.1.0"
edition = "2021"

[dependencies]
clap = { version = "4.5", features = ["derive"] }
"#;
    fs::write(path.join("Cargo.toml"), cargo_toml)?;
    
    fs::create_dir_all(path.join("src"))?;
    let main_rs = r#"use clap::Parser;

#[derive(Parser)]
struct Cli {
    name: String,
}

fn main() {
    let cli = Cli::parse();
    println!("Hello, {}!", cli.name);
}
"#;
    fs::write(path.join("src/main.rs"), main_rs)?;
    
    Ok(())
}

fn create_rust_api_template(path: &Path) -> Result<()> {
    let cargo_toml = r#"[package]
name = "my-api"
version = "0.1.0"
edition = "2021"

[dependencies]
axum = "0.7"
tokio = { version = "1", features = ["full"] }
"#;
    fs::write(path.join("Cargo.toml"), cargo_toml)?;
    
    fs::create_dir_all(path.join("src"))?;
    let main_rs = r#"use axum::{routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", get(|| async { "Hello, World!" }));
    
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
"#;
    fs::write(path.join("src/main.rs"), main_rs)?;
    
    Ok(())
}

fn create_node_api_template(path: &Path) -> Result<()> {
    let package_json = r#"{
  "name": "my-api",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
"#;
    fs::write(path.join("package.json"), package_json)?;
    
    let index_js = r#"const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.json({ message: 'Hello World!' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
"#;
    fs::write(path.join("index.js"), index_js)?;
    
    Ok(())
}

fn create_python_app_template(path: &Path) -> Result<()> {
    let pyproject_toml = r#"[tool.poetry]
name = "my-app"
version = "0.1.0"
description = ""

[tool.poetry.dependencies]
python = "^3.11"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
"#;
    fs::write(path.join("pyproject.toml"), pyproject_toml)?;
    
    let main_py = r#"def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
"#;
    fs::write(path.join("main.py"), main_py)?;
    
    Ok(())
}