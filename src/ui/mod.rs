use anyhow::Result;
use crossterm::{
    event::{self, Event, KeyCode, KeyEventKind},
    execute,
    terminal::{disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen},
};
use ratatui::{
    backend::CrosstermBackend,
    layout::{Constraint, Direction, Layout, Alignment},
    style::{Color, Modifier, Style},
    text::{Line, Span},
    widgets::{Block, Borders, List, ListItem, Paragraph},
    Terminal,
};
use std::io;

use crate::config;

struct App {
    stacks: Vec<String>,
    selected: usize,
    should_quit: bool,
}

impl App {
    fn new() -> Self {
        Self {
            stacks: config::get_available_stacks(),
            selected: 0,
            should_quit: false,
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
        let stack = &self.stacks[self.selected];
        config::apply_stack_config(stack)?;
        self.should_quit = true;
        Ok(())
    }
}

pub fn run_interactive_setup() -> Result<()> {
    // Configuration du terminal
    enable_raw_mode()?;
    let mut stdout = io::stdout();
    execute!(stdout, EnterAlternateScreen)?;
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    let mut app = App::new();
    let res = run_app(&mut terminal, &mut app);

    // Restaure le terminal
    disable_raw_mode()?;
    execute!(terminal.backend_mut(), LeaveAlternateScreen)?;
    terminal.show_cursor()?;

    if let Err(err) = res {
        println!("Erreur: {:?}", err);
    } else if !app.should_quit {
        println!("Configuration annulée");
    } else {
        println!("✓ Configuration appliquée avec succès !");
    }

    Ok(())
}

fn run_app<B: ratatui::backend::Backend>(
    terminal: &mut Terminal<B>,
    app: &mut App,
) -> Result<()> {
    loop {
        terminal.draw(|f| {
            let chunks = Layout::default()
                .direction(Direction::Vertical)
                .margin(2)
                .constraints([
                    Constraint::Length(3),
                    Constraint::Min(10),
                    Constraint::Length(3),
                ])
                .split(f.area());

            // Titre
            let title = Paragraph::new("DevKit - Configuration de projet")
                .style(Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD))
                .alignment(Alignment::Center)
                .block(Block::default().borders(Borders::ALL));
            f.render_widget(title, chunks[0]);

            // Liste des stacks
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
                    
                    let content = Line::from(vec![
                        Span::raw("  "),
                        Span::styled(stack, style),
                    ]);
                    
                    ListItem::new(content)
                })
                .collect();

            let list = List::new(items)
                .block(Block::default()
                    .borders(Borders::ALL)
                    .title("Sélectionnez une stack (↑/↓ pour naviguer, Entrée pour valider)"));
            f.render_widget(list, chunks[1]);

            // Instructions
            let help = Paragraph::new("↑/↓: Naviguer | Entrée: Sélectionner | q/Esc: Quitter")
                .style(Style::default().fg(Color::DarkGray))
                .alignment(Alignment::Center)
                .block(Block::default().borders(Borders::ALL));
            f.render_widget(help, chunks[2]);
        })?;

        // Gestion des événements
        if event::poll(std::time::Duration::from_millis(100))? {
            if let Event::Key(key) = event::read()? {
                if key.kind == KeyEventKind::Press {
                    match key.code {
                        KeyCode::Char('q') | KeyCode::Esc => {
                            app.should_quit = false;
                            break;
                        }
                        KeyCode::Down | KeyCode::Char('j') => app.next(),
                        KeyCode::Up | KeyCode::Char('k') => app.previous(),
                        KeyCode::Enter => {
                            app.select()?;
                            break;
                        }
                        _ => {}
                    }
                }
            }
        }
    }

    Ok(())
}