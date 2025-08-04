# 1. Build stage com Rust
FROM rust:1.88 as builder

# Define o diretório de trabalho dentro do contêiner.
WORKDIR /usr/src/mac_cadastro

# Copia os arquivos de configuração do Cargo para aproveitar o cache do Docker.
COPY Cargo.toml Cargo.lock ./

# Cria um arquivo main.rs temporário para compilar as dependências e cacheá-las.
# Isso acelera os builds subsequentes se apenas o código-fonte principal mudar.
RUN mkdir src && echo "fn main() {}" > src/main.rs
# Compila as dependências em modo de release.
RUN cargo build --release
# Remove o arquivo main.rs temporário e o diretório src.
RUN rm -rf src

# Copia todo o código-fonte da aplicação para o diretório de trabalho.
COPY . .

# Compila a aplicação Rust final em modo de release.
RUN cargo build --release

# 2. Runtime stage - imagem Debian atualizada e leve
# Usa uma imagem Debian slim para manter a imagem final pequena e segura.
FROM debian:bullseye-slim

# Atualiza os pacotes e instala as dependências necessárias para a aplicação Rust.
# libssl-dev é comum para aplicações Rust que usam TLS/HTTPS.
# ca-certificates é para a confiança em certificados SSL.
# rm -rf /var/lib/apt/lists/* limpa o cache de pacotes para reduzir o tamanho da imagem.
RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*

# Copia o binário compilado da etapa 'builder' para a imagem final.
# Isso garante que a imagem final não contenha ferramentas de build ou código-fonte desnecessários.
COPY --from=builder /usr/src/mac_cadastro/target/release/mac_cadastro /usr/local/bin/mac_cadastro

# Define variáveis de ambiente para a aplicação.
# RUST_LOG configura o nível de log (ex: info, debug, error).
ENV RUST_LOG=info
# DATABASE_URL é o URL do seu banco de dados.
# Em produção, este valor deve ser injetado de forma segura (ex: via segredos do Render).
ENV DATABASE_URL=""

# Expõe a porta na qual a aplicação escuta.
# Isso é uma documentação para o Docker; a porta precisará ser mapeada ao executar o contêiner.
EXPOSE 8080

# Define o comando padrão para iniciar a aplicação quando o contêiner é executado.
CMD ["mac_cadastro"]
