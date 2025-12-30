use clap::Parser;
use market_worker::{run, Command};

#[tokio::main]
async fn main() {
    let command = Command::parse();
    if let Err(e) = run(command).await {
        eprintln!("Error: {e:?}");
        std::process::exit(1);
    }
}

#[cfg(test)]
mod tests {

    #[test]
    fn test_foo() {
        assert!(true);
    }
}
