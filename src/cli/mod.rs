use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "devkit")]
#[command(about = "Configure web projects by stack", long_about = None)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Launch the interactive interface to configure the project
    Init {
        /// Project path (optional, prompted interactively if absent)
        #[arg(short, long)]
        path: Option<String>,
    },

    /// Directly configure a specific stack
    Config {
        /// Name of the stack (vue, nuxt, fastapi)
        stack: String,
        /// Project path (optional, defaults to current directory)
        #[arg(short, long)]
        path: Option<String>,
    },

    /// List all available stacks
    List,
}
