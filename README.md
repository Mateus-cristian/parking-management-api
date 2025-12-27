
# Parking Management API

Uma API RESTful robusta e escalável para gerenciamento de operações de estacionamento, desenvolvida em Ruby. Este projeto permite o controle eficiente de entradas e saídas de veículos, processamento de pagamentos e consulta de histórico por placa, sendo ideal para estacionamentos, garagens e sistemas automatizados.

## Estrutura de Pastas

```text
├── app/                # Código-fonte principal da aplicação
│   ├── application.rb      # Inicialização e configuração da aplicação
│   ├── controllers/       # Controllers (rotas e lógica de requisição)
│   ├── database/          # Configuração e acesso ao banco de dados
│   ├── entities/          # Entidades e modelos de domínio
│   ├── errors/            # Classes de erro e exceções customizadas
│   ├── handlers/          # Manipuladores de erros e middlewares
│   ├── repositories/      # Repositórios para acesso a dados
│   ├── services/          # Serviços e regras de negócio
│   └── validators/        # Validadores de dados e regras de entrada
├── config/            # Arquivos de configuração do projeto
├── docs/              # Documentação (ex: OpenAPI/Swagger)
├── infra/             # Infraestrutura (Docker, Compose, etc)
├── public/            # Arquivos públicos e estáticos (ex: Swagger UI)
├── spec/              # Testes automatizados (RSpec)
├── Gemfile            # Gerenciador de dependências Ruby
├── Makefile           # Comandos utilitários para build, testes, etc
├── README.md          # Documentação principal do projeto
└── ...                # Outros arquivos e diretórios auxiliares
```

## Ferramentas utilizadas

- **Ruby 3.2.0** — Linguagem principal da aplicação
- **Sinatra** — Framework web minimalista
- **MongoDB** — Banco de dados NoSQL
- **Mongo Ruby Driver** — Driver oficial para integração com MongoDB
- **Rspec** — Testes automatizados
- **Rubocop** — Linter e análise estática de código
- **Dotenv** — Gerenciamento de variáveis de ambiente
- **Docker & Docker Compose** — Containerização e orquestração
- **Swagger/OpenAPI** — Documentação interativa da API


## Versionamento da API

Esta API utiliza versionamento nos endpoints, permitindo evolução e manutenção sem impactar integrações existentes. Os endpoints seguem o padrão `/v1/`, facilitando futuras versões e garantindo estabilidade para os consumidores.

Exemplo:
- `POST /v1/parking`
- `PUT /v1/parking/{id}/pay`

## Principais Funcionalidades

- **Registro de Entrada e Saída**: Controle preciso de check-in e check-out de veículos com marcação de horário.
- **Gestão de Pagamentos**: Processamento seguro e idempotente de pagamentos para sessões de estacionamento.
- **Histórico por Placa**: Consulta de todo o histórico de movimentações de uma placa.
- **Idempotência**: Operações críticas são idempotentes, evitando duplicidade e garantindo segurança em reenvios.
- **Tratamento de Erros**: Respostas padronizadas e claras para todos os endpoints.
- **Documentação OpenAPI**: API totalmente documentada e disponível via Swagger UI.
- **Configuração por Ambiente**: Suporte a múltiplos ambientes (desenvolvimento, teste, produção) via arquivos `.env`.
- **Dockerização**: Pronto para deploy e desenvolvimento local com Docker Compose.

## Endpoints Principais

- `POST /v1/parking` — Registrar nova entrada de veículo
- `PUT /v1/parking/{id}/pay` — Registrar pagamento de uma sessão
- `PUT /v1/parking/{id}/out` — Marcar saída do veículo
- `GET /v1/parking/{plate}` — Consultar histórico de uma placa
- `GET /health` — Verificar saúde da API

## Como Começar

Para instalar e executar o projeto, siga um dos fluxos abaixo conforme seu ambiente:

### Instalação via Docker (Recomendado)
1. Certifique-se de ter o Docker e o Docker Compose instalados em sua máquina.
2. No diretório do projeto, execute:
	```bash
	make compose build
	make compose up
	```
	Isso irá construir as imagens e iniciar todos os serviços necessários.


### Instalação Local (Desenvolvimento)
1. Certifique-se de ter o Ruby 3.2.0 e o Bundler instalados.
	- **Linux/macOS:** Instalação direta, sem restrições.
	- **Windows:** Recomenda-se utilizar o [WSL (Windows Subsystem for Linux)](https://docs.microsoft.com/pt-br/windows/wsl/) para evitar problemas de compatibilidade com gems nativas.
2. No diretório do projeto, instale as dependências:
	```bash
	bundle install
	```
3. Inicie a aplicação localmente:
	```bash
	make start
	```

> **Dica:** Todas as operações de build, execução, testes e lint podem ser realizadas facilmente utilizando os comandos do Makefile para o modo com Docker, que centraliza e simplifica o fluxo de desenvolvimento.

## Comandos Disponíveis no Makefile

Utilize os comandos abaixo para facilitar o desenvolvimento e manutenção do projeto:

- `make compose build` — Build das imagens Docker
- `make compose up` — Sobe os containers definidos no Docker Compose
- `make compose down` — Para e remove os containers
- `make start` — Inicia a aplicação localmente (requer Ruby instalado)
- `make test` — Executa a suíte de testes automatizados (no container)
- `make rubocop` — Executa o linter Rubocop (no container)

## Documentação da API
Após iniciar a aplicação, acesse a documentação Swagger UI em:
```
http://localhost:4567/swagger/
```

## Pontos Fortes
- **Confiabilidade**: Operações idempotentes e tratamento de erros robusto evitam inconsistências.
- **Escalabilidade**: Arquitetura pronta para escalar com Docker e API stateless.
- **Manutenibilidade**: Código modular e com separação clara de responsabilidades.
- **Segurança**: Operações sensíveis exigem chaves de idempotência únicas.
- **Documentação Profissional**: OpenAPI/Swagger facilita integração e onboarding.

## Mais Informações
Consulte o arquivo `ABOUT.md` para conhecer a inspiração do projeto, detalhes sobre arquitetura, decisões técnicas e explicação sobre o uso de idempotência nos endpoints.

Feito com muito Carinho e Ruby ❤️