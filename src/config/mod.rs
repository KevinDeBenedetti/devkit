use anyhow::{Result, anyhow};
use serde::{Deserialize, Serialize};
use std::fs;

#[derive(Debug, Serialize, Deserialize)]
pub struct StackConfig {
    pub name: String,
    pub description: String,
    pub files: Vec<FileTemplate>,
    pub dependencies: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct FileTemplate {
    pub path: String,
    pub content: String,
}

pub fn get_available_stacks() -> Vec<String> {
    vec![
        "vue".to_string(),
        "nuxt".to_string(),
    ]
}

pub fn apply_stack_config(stack_name: &str) -> Result<()> {
    let config = get_stack_config(stack_name)?;
    
    // Crée les fichiers de configuration
    for file in &config.files {
        fs::create_dir_all(
            std::path::Path::new(&file.path)
                .parent()
                .unwrap_or(std::path::Path::new("."))
        )?;
        fs::write(&file.path, &file.content)?;
    }
    
    // Génère package.json avec les dépendances
    generate_package_json(&config)?;
    
    Ok(())
}

fn get_stack_config(stack_name: &str) -> Result<StackConfig> {
    match stack_name {
        "vue" => Ok(StackConfig {
            name: "Vue".to_string(),
            description: "Application Vue 3 avec TypeScript".to_string(),
            files: vec![],
            dependencies: vec!["vue".to_string()],
        }),
        "nuxt" => Ok(StackConfig {
            name: "Nuxt".to_string(),
            description: "Application Nuxt 3 avec TypeScript".to_string(),
            files: vec![],
            dependencies: vec!["nuxt".to_string()],
        }),
        _ => Err(anyhow!("Stack '{}' non reconnue", stack_name)),
    }
}

fn generate_package_json(config: &StackConfig) -> Result<()> {
    let package_json = serde_json::json!({
        "name": "my-project",
        "version": "1.0.0",
        "dependencies": config.dependencies.iter()
            .map(|dep| (dep.clone(), "latest".to_string()))
            .collect::<std::collections::HashMap<_, _>>()
    });
    
    fs::write("package.json", serde_json::to_string_pretty(&package_json)?)?;
    Ok(())
}