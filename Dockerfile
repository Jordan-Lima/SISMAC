# === 1. Build stage ===
# Usa a imagem oficial do Rust baseada no Debian Bookworm, compatível com glibc 2.37+
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

---

# === 2. Runtime stage ===
# Usa imagem Debian Bookworm Slim, compatível com binários modernos
FROM debian:bookworm-slim AS runtime

# Instala bibliotecas necessárias para execução (libssl3 e certificados SSL)
RUN apt-get update && apt-get install -y libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*

# Copia o binário do estágio anterior para o caminho final
COPY --from=builder /usr/src/mac_cadastro/target/release/mac_cadastro /usr/local/bin/mac_cadastro

# Define variáveis de ambiente da aplicação
ENV RUST_LOG=info

# Expõe a porta padrão da aplicação
EXPOSE 8080

# Adiciona um usuário sem privilégios para rodar a aplicação com mais segurança
RUN useradd -m appuser
USER appuser

# Comando padrão de execução da aplicação
CMD ["mac_cadastro"]
