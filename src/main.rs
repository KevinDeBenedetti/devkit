mod cli;
mod config;
mod ui;

use anyhow::Result;
use clap::Parser;
use cli::Cli;

fn main() -> Result<()> {
    let cli = Cli::parse();

    match cli.command {
        cli::Commands::Init { path } => {
            // Lance l'interface TUI
            ui::run_interactive_setup(path)?;
        }
        cli::Commands::Config { stack, path } => {
            let target_path = path.unwrap_or_else(|| ".".to_string());
            // Configuration directe sans TUI
            config::apply_stack_config(&stack, &target_path)?;
            println!(
                "✓ Configuration {} appliquée avec succès dans {}",
                stack, target_path
            );
        }
        cli::Commands::List => {
            // Liste les stacks disponibles
            let stacks = config::get_available_stacks();
            println!("Stacks disponibles :");
            for stack in stacks {
                println!("  • {}", stack);
            }
        }
    }

    Ok(())
}
