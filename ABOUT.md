# Sobre o Projeto

A escolha do framework **Sinatra** se deu por ser uma solução leve, minimalista e eficiente para construção de APIs REST, permitindo foco total na lógica de negócio sem sobrecarga de configuração. Essa abordagem torna o projeto mais ágil, fácil de manter e ideal para microserviços ou aplicações que não demandam toda a complexidade de frameworks maiores.

Além disso, a estrutura de pastas do projeto foi inspirada no repositório [awesome-sinatra](https://github.com/coopermaa/awesome-sinatra), que reúne vários repositórios que foram criados ou inspirados no sinatra.

Busquei criar uma solução moderna, com arquitetura limpa, documentação profissional e práticas de desenvolvimento seguras, como o uso de idempotência em endpoints críticos.

## Idempotência nos Endpoints
Idempotência é um conceito fundamental em APIs REST, especialmente para operações que podem ser executadas mais de uma vez devido a falhas de rede ou reenvio de requisições pelo cliente. Um endpoint idempotente garante que, independentemente de quantas vezes a mesma requisição for recebida, o efeito no sistema será sempre o mesmo.

### Como foi implementado
- **Chave Idempotency-Key:** Para endpoints sensíveis (criação, pagamento e checkout), a API exige o envio de um header `Idempotency-Key` único por operação.
- **Armazenamento:** Cada chave é registrada no banco de dados junto com o resultado da operação. Se a mesma chave for reutilizada, a resposta será a mesma da primeira execução, sem duplicar efeitos colaterais.
- **Benefícios:**
  - Evita cobranças duplicadas.
  - Garante integridade dos dados mesmo em cenários de falha ou timeout.
  - Melhora a experiência do usuário e a confiabilidade do sistema.

### Exemplo de uso
```http
PUT /v1/parking/{id}/pay
Idempotency-Key: 123e4567-e89b-12d3-a456-426614174000
```
Se o cliente enviar a mesma requisição com a mesma chave, o sistema irá retornar o mesmo resultado, sem processar o pagamento novamente.



## Considerações

Este projeto é resultado de estudo, prática e paixão por desenvolvimento de APIs robustas e seguras.
