# 1. Build stage
FROM rust:1.70 as builder

# Create app directory
WORKDIR /usr/src/mac_cadastro

# Copia os arquivos do Cargo
COPY Cargo.toml Cargo.lock ./

# Baixa as dependências e compila só as dependências (cache layer)
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -rf src

# Copia o código fonte completo
COPY . .

# Compila a aplicação de verdade
RUN cargo build --release

# 2. Runtime stage - imagem final menor, usando a build estática
FROM debian:buster-slim

# Instala dependências necessárias para rodar seu binário
RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*

# Copia o binário do builder
COPY --from=builder /usr/src/mac_cadastro/target/release/mac_cadastro /usr/local/bin/mac_cadastro

# Define variáveis de ambiente (você pode sobrescrever no deploy)
ENV RUST_LOG=info
ENV DATABASE_URL=""

# Expõe a porta que sua API usa
EXPOSE 8080

# Executa o binário
CMD ["mac_cadastro"]
