# Build com Rust oficial
FROM rust:1.88-slim-bookworm AS builder

WORKDIR /usr/src/mac_cadastro

COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -rf src

COPY . .
RUN cargo build --release

# Runtime com mesma base
FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/mac_cadastro/target/release/mac_cadastro /usr/local/bin/mac_cadastro

ENV RUST_LOG=info
EXPOSE 8080
RUN useradd -m appuser
USER appuser
CMD ["mac_cadastro"]
