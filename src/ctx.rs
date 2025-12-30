use anyhow::{Context as AnyhowContext, Result};
use std::env;

pub struct Ctx {
    pub admin_endpoint: String,
}

impl Ctx {
    pub fn from_env() -> Result<Self> {
        let admin_endpoint =
            env::var("MIRAIMA_ADMIN_ENDPOINT").context("MIRAIMA_ADMIN_ENDPOINT not set")?;
        Ok(Self { admin_endpoint })
    }
}
