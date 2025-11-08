use anyhow::Result;
use crossterm::{
    event::{self, Event, KeyCode, KeyEventKind},
    execute,
    terminal::{disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen},
};
use ratatui::{
    backend::CrosstermBackend,
    layout::{Alignment, Constraint, Direction, Layout},
    style::{Color, Modifier, Style},
    text::{Line, Span},
    widgets::{Block, Borders, List, ListItem, Paragraph},
    Terminal,
};
use std::fs;
use std::io;
use std::path::Path;

use crate::config;

enum AppState {
    SelectingPath,
    SelectingStack,
    Confirming,
    ContinueOrQuit,
}

struct App {
    stacks: Vec<String>,
    selected: usize,
    should_quit: bool,
    state: AppState,
    path_input: String,
    target_path: String,
    tree_lines: Vec<String>,
    selected_stack: String,
    continue_selected: usize, // 0 = Configurer un autre projet, 1 = Quitter
}

impl App {
    fn new() -> Self {
        let current_dir = std::env::current_dir()
            .ok()
            .and_then(|p| p.to_str().map(String::from))
            .unwrap_or_else(|| ".".to_string());

        let tree_lines = build_tree_lines(&current_dir, 3);

        Self {
            stacks: config::get_available_stacks(),
            selected: 0,
            should_quit: false,
            state: AppState::SelectingPath,
            path_input: String::new(),
            target_path: String::new(),
            tree_lines,
            selected_stack: String::new(),
            continue_selected: 0,
        }
    }

    fn next(&mut self) {
        if self.selected < self.stacks.len() - 1 {
            self.selected += 1;
        }
    }

    fn previous(&mut self) {
        if self.selected > 0 {
            self.selected -= 1;
        }
    }

    fn select(&mut self) -> Result<()> {
        self.selected_stack = self.stacks[self.selected].clone();
        self.state = AppState::Confirming;
        Ok(())
    }

    fn confirm_and_apply(&mut self) -> Result<()> {
        config::apply_stack_config(&self.selected_stack, &self.target_path)?;
        self.state = AppState::ContinueOrQuit;
        Ok(())
    }

    fn cancel_confirmation(&mut self) {
        self.state = AppState::SelectingStack;
    }

    fn reset_for_new_project(&mut self) {
        let current_dir = std::env::current_dir()
            .ok()
            .and_then(|p| p.to_str().map(String::from))
            .unwrap_or_else(|| ".".to_string());

        self.path_input.clear();
        self.target_path.clear();
        self.selected = 0;
        self.continue_selected = 0;
        self.tree_lines = build_tree_lines(&current_dir, 3);
        self.state = AppState::SelectingPath;
    }

    fn next_continue(&mut self) {
        if self.continue_selected < 1 {
            self.continue_selected += 1;
        }
    }

    fn previous_continue(&mut self) {
        if self.continue_selected > 0 {
            self.continue_selected -= 1;
        }
    }

    fn confirm_path(&mut self) {
        self.target_path = if self.path_input.is_empty() {
            ".".to_string()
        } else {
            self.path_input.clone()
        };
        self.state = AppState::SelectingStack;
    }

    fn handle_path_input(&mut self, c: char) {
        self.path_input.push(c);
    }

    fn delete_path_char(&mut self) {
        self.path_input.pop();
    }

    fn update_tree(&mut self) {
        let path = if self.path_input.is_empty() {
            "."
        } else {
            &self.path_input
        };
        self.tree_lines = build_tree_lines(path, 3);
    }
}

pub fn run_interactive_setup(path: Option<String>) -> Result<()> {
    if let Some(p) = path {
        // Si le chemin est fourni, utiliser l'interface TUI directement
        run_interactive_setup_with_path(p)
    } else {
        // Sinon, utiliser l'interface TUI complète
        run_interactive_setup_terminal()
    }
}

fn run_interactive_setup_with_path(target_path: String) -> Result<()> {
    enable_raw_mode()?;
    let mut stdout = io::stdout();
    execute!(stdout, EnterAlternateScreen)?;
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    let mut app = App::new();
    app.target_path = target_path;
    app.state = AppState::SelectingStack;

    let res = run_app(&mut terminal, &mut app);

    disable_raw_mode()?;
    execute!(terminal.backend_mut(), LeaveAlternateScreen)?;
    terminal.show_cursor()?;

    if let Err(err) = res {
        println!("Erreur: {:?}", err);
    } else if !app.should_quit {
        println!("Configuration annulée");
    }

    Ok(())
}

fn run_interactive_setup_terminal() -> Result<()> {
    enable_raw_mode()?;
    let mut stdout = io::stdout();
    execute!(stdout, EnterAlternateScreen)?;
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    let mut app = App::new();
    let res = run_app(&mut terminal, &mut app);

    disable_raw_mode()?;
    execute!(terminal.backend_mut(), LeaveAlternateScreen)?;
    terminal.show_cursor()?;

    if let Err(err) = res {
        println!("Erreur: {:?}", err);
    } else if !app.should_quit {
        println!("Configuration annulée");
    }

    Ok(())
}

fn run_app<B: ratatui::backend::Backend>(terminal: &mut Terminal<B>, app: &mut App) -> Result<()> {
    loop {
        terminal.draw(|f| match app.state {
            AppState::SelectingPath => {
                let chunks = Layout::default()
                    .direction(Direction::Vertical)
                    .margin(2)
                    .constraints([
                        Constraint::Length(3),
                        Constraint::Length(5),
                        Constraint::Min(10),
                        Constraint::Length(3),
                    ])
                    .split(f.area());

                let title = Paragraph::new("DevKit - Project Setup")
                    .style(
                        Style::default()
                            .fg(Color::Cyan)
                            .add_modifier(Modifier::BOLD),
                    )
                    .alignment(Alignment::Center)
                    .block(Block::default().borders(Borders::ALL));
                f.render_widget(title, chunks[0]);

                let input_text = if app.path_input.is_empty() {
                    ". (current directory)"
                } else {
                    &app.path_input
                };

                let input = Paragraph::new(input_text)
                    .style(Style::default().fg(Color::Yellow))
                    .block(
                        Block::default()
                            .borders(Borders::ALL)
                            .title("📂 Project Path (Enter to confirm)"),
                    );
                f.render_widget(input, chunks[1]);

                // Arborescence
                let tree_items: Vec<ListItem> = app
                    .tree_lines
                    .iter()
                    .map(|line| {
                        ListItem::new(Line::from(Span::styled(
                            line.clone(),
                            Style::default().fg(Color::Gray),
                        )))
                    })
                    .collect();

                let tree = List::new(tree_items).block(
                    Block::default()
                        .borders(Borders::ALL)
                        .title("📁 Project Tree"),
                );
                f.render_widget(tree, chunks[2]);

                let help = Paragraph::new("Type path | Enter: Confirm | Esc: Cancel")
                    .style(Style::default().fg(Color::DarkGray))
                    .alignment(Alignment::Center)
                    .block(Block::default().borders(Borders::ALL));
                f.render_widget(help, chunks[3]);
            }
            AppState::SelectingStack => {
                let chunks = Layout::default()
                    .direction(Direction::Vertical)
                    .margin(2)
                    .constraints([
                        Constraint::Length(3),
                        Constraint::Min(10),
                        Constraint::Length(3),
                    ])
                    .split(f.area());

                let title = Paragraph::new(format!("DevKit - Project: {}", app.target_path))
                    .style(
                        Style::default()
                            .fg(Color::Cyan)
                            .add_modifier(Modifier::BOLD),
                    )
                    .alignment(Alignment::Center)
                    .block(Block::default().borders(Borders::ALL));
                f.render_widget(title, chunks[0]);

                let items: Vec<ListItem> = app
                    .stacks
                    .iter()
                    .enumerate()
                    .map(|(i, stack)| {
                        let style = if i == app.selected {
                            Style::default()
                                .fg(Color::Black)
                                .bg(Color::Cyan)
                                .add_modifier(Modifier::BOLD)
                        } else {
                            Style::default().fg(Color::White)
                        };

                        let content = Line::from(vec![Span::raw("  "), Span::styled(stack, style)]);
                        ListItem::new(content)
                    })
                    .collect();

                let list = List::new(items).block(
                    Block::default()
                        .borders(Borders::ALL)
                        .title("📚 Select a stack"),
                );
                f.render_widget(list, chunks[1]);

                let help = Paragraph::new("↑/↓: Navigate | Enter: Select | Esc: Cancel")
                    .style(Style::default().fg(Color::DarkGray))
                    .alignment(Alignment::Center)
                    .block(Block::default().borders(Borders::ALL));
                f.render_widget(help, chunks[2]);
            }
            AppState::Confirming => {
                let chunks = Layout::default()
                    .direction(Direction::Vertical)
                    .margin(2)
                    .constraints([
                        Constraint::Length(3),
                        Constraint::Min(10),
                        Constraint::Length(3),
                    ])
                    .split(f.area());

                let title = Paragraph::new("DevKit - Confirmation")
                    .style(
                        Style::default()
                            .fg(Color::Cyan)
                            .add_modifier(Modifier::BOLD),
                    )
                    .alignment(Alignment::Center)
                    .block(Block::default().borders(Borders::ALL));
                f.render_widget(title, chunks[0]);

                let confirmation_text = format!(
                    "Do you want to apply the {} configuration into {}?\n\n\
                    The following files will be created:\n\
                    • Makefile\n\
                    • Dockerfile\n\
                    • .dockerignore\n\n\
                    This action will create or overwrite these files.",
                    app.selected_stack, app.target_path
                );

                let text = Paragraph::new(confirmation_text)
                    .style(Style::default().fg(Color::White))
                    .alignment(Alignment::Left)
                    .block(Block::default().borders(Borders::ALL));
                f.render_widget(text, chunks[1]);

                let help = Paragraph::new("Enter: Confirm | Esc: Cancel")
                    .style(Style::default().fg(Color::DarkGray))
                    .alignment(Alignment::Center)
                    .block(Block::default().borders(Borders::ALL));
                f.render_widget(help, chunks[2]);
            }
            AppState::ContinueOrQuit => {
                let chunks = Layout::default()
                    .direction(Direction::Vertical)
                    .margin(2)
                    .constraints([
                        Constraint::Length(3),
                        Constraint::Length(7),
                        Constraint::Length(3),
                    ])
                    .split(f.area());

                let title = Paragraph::new("✓ Setup complete!")
                    .style(
                        Style::default()
                            .fg(Color::Green)
                            .add_modifier(Modifier::BOLD),
                    )
                    .alignment(Alignment::Center)
                    .block(Block::default().borders(Borders::ALL));
                f.render_widget(title, chunks[0]);

                let options = vec![
                    "🔄 Configure another project (monorepo)",
                    "🚪 Quit assistant",
                ];

                let items: Vec<ListItem> = options
                    .iter()
                    .enumerate()
                    .map(|(i, option)| {
                        let style = if i == app.continue_selected {
                            Style::default()
                                .fg(Color::Black)
                                .bg(Color::Green)
                                .add_modifier(Modifier::BOLD)
                        } else {
                            Style::default().fg(Color::White)
                        };

                        let content =
                            Line::from(vec![Span::raw("  "), Span::styled(*option, style)]);
                        ListItem::new(content)
                    })
                    .collect();

                let list = List::new(items).block(
                    Block::default()
                        .borders(Borders::ALL)
                        .title("What would you like to do?"),
                );
                f.render_widget(list, chunks[1]);

                let help = Paragraph::new("↑/↓: Navigate | Enter: Confirm")
                    .style(Style::default().fg(Color::DarkGray))
                    .alignment(Alignment::Center)
                    .block(Block::default().borders(Borders::ALL));
                f.render_widget(help, chunks[2]);
            }
        })?;

        if event::poll(std::time::Duration::from_millis(100))? {
            if let Event::Key(key) = event::read()? {
                if key.kind == KeyEventKind::Press {
                    match app.state {
                        AppState::SelectingPath => match key.code {
                            KeyCode::Char(c) => {
                                app.handle_path_input(c);
                                app.update_tree();
                            }
                            KeyCode::Backspace => {
                                app.delete_path_char();
                                app.update_tree();
                            }
                            KeyCode::Enter => app.confirm_path(),
                            KeyCode::Esc => {
                                app.should_quit = false;
                                break;
                            }
                            _ => {}
                        },
                        AppState::SelectingStack => match key.code {
                            KeyCode::Char('q') | KeyCode::Esc => {
                                app.should_quit = false;
                                break;
                            }
                            KeyCode::Down | KeyCode::Char('j') => app.next(),
                            KeyCode::Up | KeyCode::Char('k') => app.previous(),
                            KeyCode::Enter => {
                                app.select()?;
                            }
                            _ => {}
                        },
                        AppState::Confirming => match key.code {
                            KeyCode::Enter => {
                                app.confirm_and_apply()?;
                            }
                            KeyCode::Esc => app.cancel_confirmation(),
                            _ => {}
                        },
                        AppState::ContinueOrQuit => match key.code {
                            KeyCode::Down | KeyCode::Char('j') => app.next_continue(),
                            KeyCode::Up | KeyCode::Char('k') => app.previous_continue(),
                            KeyCode::Enter => {
                                if app.continue_selected == 0 {
                                    // Configurer un autre projet
                                    app.reset_for_new_project();
                                } else {
                                    // Quitter
                                    app.should_quit = true;
                                    break;
                                }
                            }
                            KeyCode::Esc => {
                                app.should_quit = true;
                                break;
                            }
                            _ => {}
                        },
                    }
                }
            }
        }
    }

    Ok(())
}

/// Construit les lignes de l'arborescence pour l'affichage
fn build_tree_lines(path: &str, max_depth: usize) -> Vec<String> {
    let mut lines = Vec::new();
    let path = Path::new(path);

    if !path.exists() {
        lines.push("  (chemin inexistant)".to_string());
        return lines;
    }

    let display_name = path
        .file_name()
        .and_then(|n| n.to_str())
        .unwrap_or(path.to_str().unwrap_or("."));

    lines.push(format!("📂 {} (./)", display_name));
    build_tree_recursive(path, &mut lines, "", 0, max_depth, "./".to_string());

    lines
}

/// Fonction récursive pour construire l'arborescence
fn build_tree_recursive(
    path: &Path,
    lines: &mut Vec<String>,
    prefix: &str,
    depth: usize,
    max_depth: usize,
    current_path: String,
) {
    if depth >= max_depth {
        return;
    }

    let Ok(entries) = fs::read_dir(path) else {
        return;
    };

    let mut entries: Vec<_> = entries.filter_map(|e| e.ok()).collect();
    entries.sort_by_key(|e| e.path());

    let filtered_entries: Vec<_> = entries
        .into_iter()
        .filter(|entry| {
            let file_name = entry.file_name();
            let file_name_str = file_name.to_string_lossy();
            // Ne garder que les dossiers
            entry.path().is_dir()
                && !file_name_str.starts_with('.')
                && file_name_str != "node_modules"
                && file_name_str != "target"
                && file_name_str != "dist"
                && file_name_str != "build"
        })
        .collect();

    for (i, entry) in filtered_entries.iter().enumerate() {
        let is_last = i == filtered_entries.len() - 1;
        let connector = if is_last { "└── " } else { "├── " };
        let file_name = entry.file_name();
        let file_name_str = file_name.to_string_lossy();

        let relative_path = format!("{}{}", current_path, file_name_str);

        let display_line = format!(
            "{}{}{} {} ({})",
            prefix, connector, "📁", file_name_str, relative_path
        );

        lines.push(display_line);

        let new_prefix = format!("{}{}", prefix, if is_last { "    " } else { "│   " });
        let new_path = format!("{}/", relative_path);
        build_tree_recursive(
            &entry.path(),
            lines,
            &new_prefix,
            depth + 1,
            max_depth,
            new_path,
        );
    }
}
