use std::time::Duration;

use anyhow::{Context as AnyhowContext, Result};
use clap::{Parser, ValueEnum};
use ctx::Ctx;

mod ctx;

#[derive(Debug, Clone, ValueEnum)]
pub enum Market {
    BTCUSD,
}

#[derive(Debug, Parser)]
#[command(name = "market-worker")]
pub enum Command {
    Create { market: Market },
    Resolve,
}

pub async fn run(command: Command) -> Result<()> {
    let ctx: Ctx = Ctx::from_env().context("failed to load ctx")?;
    let client = reqwest::Client::builder()
        .timeout(Duration::from_secs(5))
        .build()
        .context("failed to build http client")?;

    match command {
        Command::Create { market } => {
            println!("{:?}", market);
            let url = format!("{}/admin/internal/", ctx.admin_endpoint);
            let resp = client.get(&url).send().await.context("request failed")?;
            println!("resp: {}", resp.text().await?);
        }
        Command::Resolve => {
            println!("resolve called");
        }
    }
    Ok(())
}
