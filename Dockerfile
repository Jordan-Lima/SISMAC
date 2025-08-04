# 1. Build stage com Rust
FROM rust:1.88 AS builder

# Instala as dependências necessárias para compilar OpenSSL (pkg-config + libssl-dev)
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/mac_cadastro

COPY Cargo.toml Cargo.lock ./

RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release

RUN rm -rf src

COPY . .

RUN cargo build --release

# 2. Runtime stage - imagem Debian atualizada e leve
FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/mac_cadastro/target/release/mac_cadastro /usr/local/bin/mac_cadastro

ENV RUST_LOG=info
ENV DATABASE_URL=""

EXPOSE 8080

CMD ["mac_cadastro"]
