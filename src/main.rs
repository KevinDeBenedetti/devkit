use clap::{Parser, Subcommand};
use anyhow::Result;
mod cli;

#[derive(Parser)]
#[command(name = "installer")]
#[command(version = "0.1.0")]
#[command(about = "Project installer tool", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    Init {
        template: String,

        #[arg(default_value = ".")]
        output: String,
    },

    Docker {
        #[arg(long)]
        compose: bool,
    },

    Makefile,

    List,

    Version
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Commands::Init { template, output } => {
            cli::commands::init(&template, &output)?;
        }
        Commands::Docker { compose } => {
            cli::commands::setup_docker(compose)?;
        }
        Commands::Makefile => {
            cli::commands::setup_makefile()?;
        }
        Commands::List => {
            cli::commands::list_templates()?;
        }
        Commands::Version => {
            println!("installer v{}", env!("CARGO_PKG_VERSION"));
        }
    }

    Ok(())
}