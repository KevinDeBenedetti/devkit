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
            // Launch the TUI interface
            ui::run_interactive_setup(path)?;
        }
        cli::Commands::Config { stack, path } => {
            let target_path = path.unwrap_or_else(|| ".".to_string());
            // Direct configuration without TUI
            config::apply_stack_config(&stack, &target_path)?;
            println!(
                "✓ Configuration {} applied successfully in {}",
                stack, target_path
            );
        }
        cli::Commands::List => {
            // List available stacks
            let stacks = config::get_available_stacks();
            println!("Available stacks:");
            for stack in stacks {
                println!("  • {}", stack);
            }
        }
    }

    Ok(())
}
