use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "devkit")]
#[command(about = "Configuration de projets web par stack", long_about = None)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Lance l'interface interactive pour configurer le projet
    Init {
        /// Chemin du projet (optionnel, demandé interactivement si absent)
        #[arg(short, long)]
        path: Option<String>,
    },

    /// Configure directement une stack spécifique
    Config {
        /// Nom de la stack (vue, nuxt, fastapi)
        stack: String,
        /// Chemin du projet (optionnel, utilise le répertoire courant par défaut)
        #[arg(short, long)]
        path: Option<String>,
    },

    /// Liste toutes les stacks disponibles
    List,
}
