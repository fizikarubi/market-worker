use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "market-worker")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    Foo,
    Bar,
}

fn main() {
    let cli = Cli::parse();

    match cli.command {
        Commands::Foo => println!("foo\n"),
        Commands::Bar => println!("bar\n"),
    }
}
