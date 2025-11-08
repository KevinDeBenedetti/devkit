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
    Init,
    
    /// Configure directement une stack spécifique
    Config {
        /// Nom de la stack (react, vue, angular, etc.)
        stack: String,
    },
    
    /// Liste toutes les stacks disponibles
    List,
}