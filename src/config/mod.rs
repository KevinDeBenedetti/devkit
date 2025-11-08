use anyhow::{anyhow, Context, Result};
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::{Path, PathBuf};

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
    vec!["vue".to_string(), "nuxt".to_string(), "fastapi".to_string()]
}

pub fn apply_stack_config(stack_name: &str, base_path: &str) -> Result<()> {
    let config = get_stack_config(stack_name)?;
    let base_path = PathBuf::from(base_path);

    // Affiche l'arborescence actuelle
    println!("\n📂 Répertoire cible : {}", base_path.display());
    display_tree(&base_path, 0, 2)?;

    println!("\n🔧 Configuration de la stack {}...", config.name);

    // Crée les fichiers de configuration (Dockerfile, Makefile, .dockerignore, etc.)
    for file in &config.files {
        let file_path = base_path.join(&file.path);
        create_file(&file_path, &file.content)
            .context(format!("Erreur lors de la création de {}", file.path))?;
    }

    println!("\n✓ Configuration terminée !");
    println!("\n📂 Arborescence mise à jour :");
    display_tree(&base_path, 0, 2)?;

    println!("\n📝 Prochaines étapes :");
    println!(
        "  cd {}        # Se déplacer dans le projet",
        base_path.display()
    );
    println!("  make help      # Voir toutes les commandes disponibles");
    println!("  make install   # Installer les dépendances");
    println!("  make dev       # Lancer en développement");

    Ok(())
}

/// Affiche l'arborescence d'un répertoire
fn display_tree(path: &Path, depth: usize, max_depth: usize) -> Result<()> {
    if depth > max_depth {
        return Ok(());
    }

    if !path.exists() {
        println!("{}└── (répertoire vide ou inexistant)", "  ".repeat(depth));
        return Ok(());
    }

    let entries = fs::read_dir(path)
        .context("Impossible de lire le répertoire")?
        .filter_map(|e| e.ok())
        .collect::<Vec<_>>();

    for (i, entry) in entries.iter().enumerate() {
        let is_last = i == entries.len() - 1;
        let prefix = if is_last { "└── " } else { "├── " };
        let file_name = entry.file_name();
        let file_name_str = file_name.to_string_lossy();

        // Ignore les dossiers cachés et node_modules
        if file_name_str.starts_with('.')
            || file_name_str == "node_modules"
            || file_name_str == "target"
        {
            continue;
        }

        println!("{}{}{}", "  ".repeat(depth), prefix, file_name_str);

        if entry.path().is_dir() && depth < max_depth {
            display_tree(&entry.path(), depth + 1, max_depth)?;
        }
    }

    Ok(())
}

/// Crée un fichier avec son contenu
fn create_file(path: &Path, content: &str) -> Result<()> {
    // Crée les dossiers parents si nécessaire
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).context(format!(
            "Impossible de créer le dossier {}",
            parent.display()
        ))?;
    }

    // Écrit le fichier
    fs::write(path, content).context(format!("Impossible d'écrire {}", path.display()))?;

    println!("  ✓ {} créé", path.display());
    Ok(())
}

fn get_stack_config(stack_name: &str) -> Result<StackConfig> {
    match stack_name {
        "vue" => Ok(StackConfig {
            name: "Vue".to_string(),
            description: "Application Vue 3 avec TypeScript".to_string(),
            files: vec![
                FileTemplate {
                    path: "Makefile".to_string(),
                    content: include_str!("../templates/vue/Makefile").to_string(),
                },
                FileTemplate {
                    path: "Dockerfile".to_string(),
                    content: include_str!("../templates/vue/Dockerfile").to_string(),
                },
                FileTemplate {
                    path: ".dockerignore".to_string(),
                    content: include_str!("../templates/vue/.dockerignore").to_string(),
                },
            ],
            dependencies: vec![
                "vue".to_string(),
                "vite".to_string(),
                "typescript".to_string(),
            ],
        }),
        "nuxt" => Ok(StackConfig {
            name: "Nuxt".to_string(),
            description: "Application Nuxt 3 avec TypeScript".to_string(),
            files: vec![
                FileTemplate {
                    path: "Makefile".to_string(),
                    content: include_str!("../templates/nuxt/Makefile").to_string(),
                },
                FileTemplate {
                    path: "Dockerfile".to_string(),
                    content: include_str!("../templates/nuxt/Dockerfile").to_string(),
                },
                FileTemplate {
                    path: ".dockerignore".to_string(),
                    content: include_str!("../templates/nuxt/.dockerignore").to_string(),
                },
            ],
            dependencies: vec!["nuxt".to_string(), "@nuxt/devtools".to_string()],
        }),
        "fastapi" => Ok(StackConfig {
            name: "FastAPI".to_string(),
            description: "API REST avec FastAPI et Python".to_string(),
            files: vec![
                FileTemplate {
                    path: "Makefile".to_string(),
                    content: include_str!("../templates/fastapi/Makefile").to_string(),
                },
                FileTemplate {
                    path: "Dockerfile".to_string(),
                    content: include_str!("../templates/fastapi/Dockerfile").to_string(),
                },
                FileTemplate {
                    path: ".dockerignore".to_string(),
                    content: include_str!("../templates/fastapi/.dockerignore").to_string(),
                },
            ],
            dependencies: vec![
                "fastapi".to_string(),
                "uvicorn[standard]".to_string(),
                "pydantic".to_string(),
            ],
        }),
        _ => Err(anyhow!("Stack '{}' non reconnue", stack_name)),
    }
}
