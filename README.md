# SISMAC - Sistema de Cadastro e Gerenciamento de MACs  
[![Java](https://img.shields.io/badge/Java-21-blue.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.1-green.svg)](https://spring.io/projects/spring-boot)
[![Angular](https://img.shields.io/badge/Angular-17-red.svg)](https://angular.io/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange.svg)](https://www.mysql.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)]()

> Sistema desenvolvido para gerenciar dispositivos autorizados por endereço MAC nas lojas **Comercial Villa Simpatia**, integrando com a API do controlador UniFi.

---

## 🔗 Repositórios

- 🔙 **Backend (Spring Boot)**: [github.com/seu-usuario/sismac-backend](https://github.com/jordan-lima/sismac/backend)  
- 🎨 **Frontend (Angular)**: [github.com/seu-usuario/sismac-frontend](https://github.com/jordan-lima/sismac/frontend)

---

## 🧩 Tecnologias Utilizadas

| Camada     | Tecnologias |
|------------|-------------|
| Backend    | Java 21, Spring Boot, Spring Security, Spring Data JPA |
| Frontend   | Angular, TypeScript |
| Banco      | MySQL |
| Integração | API UniFi Controller |

---

## ⚙️ Funcionalidades

### Login
- Apenas **admins** podem acessar o sistema.

### Página `/admin`
- ✅ Listagem de dispositivos (MAC).
- ➕ Cadastro de novos dispositivos.
- ❌ Remoção de dispositivos.
- 🔒 Acesso restrito a administradores.

### Integração com UniFi
- Cadastro de MACs diretamente na **UniFi Controller API**.

---

## 🚀 Como rodar o projeto

### 📦 Backend (Spring Boot)

```bash
git clone https://github.com/jordan-lima/sismac/backend.git
cd sismac-backend

# Configure o arquivo application.properties
# e execute:
./mvnw spring-boot:run
```

### 🖥️ Frontend (Angular)

```bash
git clone https://github.com/jordan-lima/sismac/frontend.git
cd sismac-frontend

npm install
ng serve
```

### 🗄️ Banco de Dados

```sql
CREATE DATABASE sismac;
```

> O JPA se encarrega da criação automática das tabelas.

---

## 🔐 Usuário de Teste

| Usuário | Senha     | Papel |
|---------|-----------|-------|
| admin   | admin123  | ADMIN |

---

## 📁 Estrutura do Projeto

### Backend

```
src/
├── controller/
├── service/
├── repository/
├── model/
├── config/            # Spring Security configs
└── integration/       # Comunicação com a API UniFi
```

### Frontend

```
src/
├── app/
│   ├── components/
│   ├── services/
│   ├── pages/
```

---

## 📡 Integração com UniFi

A aplicação se conecta ao **UniFi Controller** via API REST para:

- Autorizar dispositivos por MAC,
- Aplicar políticas,
- Validar dispositivos ativos.

---

## 🤝 Contribuindo

Sinta-se à vontade para enviar melhorias ou sugestões:

1. Faça um fork
2. Crie uma branch: `git checkout -b feature-minha-feature`
3. Commit suas mudanças: `git commit -m 'feat: minha feature'`
4. Push: `git push origin feature-minha-feature`
5. Abra um Pull Request

---

## 📜 Licença

Distribuído sob a licença **MIT**.

```
MIT License

Copyright (c) 2025 Jordan Lima

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     
copies of the Software, and to permit persons to whom the Software is         
furnished to do so, subject to the following conditions:                       

The above copyright notice and this permission notice shall be included in    
all copies or substantial portions of the Software.                           

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     
THE SOFTWARE.
```

---

## ✨ Desenvolvido por

**Jordan Lima** – [jordanlima.dev](https://jordanlima.dev)
