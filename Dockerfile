# === 1. Build stage ===
FROM rust:1.88-slim-bookworm AS builder

# Define o diretório de trabalho no contêiner
WORKDIR /usr/src/mac_cadastro

# Copia arquivos de configuração para aproveitar o cache
COPY Cargo.toml Cargo.lock ./

# Cria main.rs temporário para compilar dependências (cache eficiente)
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -rf src

# Copia o restante do código-fonte da aplicação
COPY . .

# Compila o binário final em modo release
RUN cargo build --release

# === 2. Runtime stage ===
FROM debian:bookworm-slim AS runtime

# Instala bibliotecas necessárias para execução
RUN apt-get update && apt-get install -y libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*

# Copia o binário do estágio anterior
COPY --from=builder /usr/src/mac_cadastro/target/release/mac_cadastro /usr/local/bin/mac_cadastro

# Define variáveis de ambiente
ENV RUST_LOG=info

# Expõe a porta usada pela aplicação
EXPOSE 8080

# Executa como usuário sem privilégios (boa prática)
RUN useradd -m appuser
USER appuser

# Comando padrão
CMD ["mac_cadastro"]
