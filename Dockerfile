# Build stage
FROM rust:1.92.0-slim AS builder

WORKDIR /app
COPY . .
RUN cargo build --release

# Runtime stage
FROM debian:bookworm-slim

COPY --from=builder /app/target/release/market-worker /usr/local/bin/market-worker

ENTRYPOINT ["market-worker"]
