mod cli;
mod ui;
mod config;

use anyhow::Result;
use clap::Parser;
use cli::Cli;

fn main() -> Result<()> {
    let cli = Cli::parse();
    
    match cli.command {
        cli::Commands::Init => {
            // Lance l'interface TUI
            ui::run_interactive_setup()?;
        }
        cli::Commands::Config { stack } => {
            // Configuration directe sans TUI
            config::apply_stack_config(&stack)?;
            println!("✓ Configuration {} appliquée avec succès", stack);
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