# Projeto Rebase Labs T12

## Descrição do Projeto
Uma aplicação que exibe a listagem de exames médicos e seus detalhes

## Funcionalidades
✔️ Listagem de todos os tokens de exames na tela inicial

✔️ Tela de detalhes de um exame com todos os resultados

✔️ Campo de busca por um exame via token

✔️ Importação de exames via arquivo CSV, com processamento assíncrono dos dados

## Pré-Requisitos
- [Docker](https://docs.docker.com/get-docker/)

## Como rodar a aplicação
No terminal, clone o projeto:
```
git clone https://github.com/thalytalima211/rebase-labs.git
```

Entre na pasta do projeto:
```
cd /rebase-labs
```

Execute o comando para subir toda a aplicação:
```
docker compose up
```

Se deseja importar dados iniciais para a aplicação, importe os dados do arquivo data.csv. rodando em outro terminal o comando:
```
docker exec myapp ruby db/import_from_csv.rb
```

Após esses passos, a aplicação já deve estar disponível em:
```
http://localhost:3000/
```

## API
A aplicação disponibiliza uma API que faz a conexão com os dados do banco.

### Endpoints
- `GET /read_database` - Este endpoint retorna um JSON que demonstra a estrutura real de colunas do banco de dados, para exemplificar a conexão do banco com a aplicação API

Exemplo de resposta:
```json
[
 {
  "cpf": "048.973.170-88",
  "name": "Emilly Batista Neto",
  "email": "gerald.crona@ebert-quigley.com",
  "birthday": "2001-03-11",
  "address": "165 Rua Rafaela",
  "city": "Ituverava",
  "state": "Alagoas",
  "doctor_crm": "B000BJ20J4",
  "doctor_crm_state": "PI",
  "doctor_name": "Maria Luiza Pires",
  "doctor_email": "denna@wisozk.biz",
  "result_token": "IQCZ17",
  "result_date": "2021-08-05",
  "test_type": "hemácias",
  "test_type_limits": "45-52",
  "test_type_result": "97"
 },
 {
  "cpf": "048.973.170-88",
  "name": "Emilly Batista Neto",
  "email": "gerald.crona@ebert-quigley.com",
  "birthday": "2001-03-11",
  "address": "165 Rua Rafaela",
  "city": "Ituverava",
  "state": "Alagoas",
  "doctor_crm": "B000BJ20J4",
  "doctor_crm_state": "PI",
  "doctor_name": "Maria Luiza Pires",
  "doctor_email": "denna@wisozk.biz",
  "result_token": "IQCZ17",
  "result_date": "2021-08-05",
  "test_type": "leucócitos",
  "test_type_limits": "9-61",
  "test_type_result": "89"
 }
]
```

- `GET /api/tests` - Esse endpoint retorna a listagem de todos os tokens de testes disponíveis no banco, com uma melhor organização e abstração do JSON para exibição das informações.

Exemplo de resposta:
```json
[
 {
  "result_token": "00S0MD",
  "result_date": "2022-03-03",
  "cpf": "099.204.552-53",
  "name": "Ladislau Duarte",
  "email": "lisha@rosenbaum.org",
  "birthday": "1981-02-02",
  "address": "s/n Marginal Pietro",
  "city": "Peritiba",
  "state": "Rio Grande do Norte",
  "doctor": {
   "crm": "B000BJ8TIA",
   "crm_state": "PR",
   "name": "Ana Sophia Aparício Neto",
   "email": "corene.hane@pagac.io"
  }
 },
 {
  "result_token": "06LD0G",
  "result_date": "2021-05-15",
  "cpf": "003.596.348-42",
  "name": "Valentina Cruz",
  "email": "cortez.dickens@farrell.name",
  "birthday": "1979-04-04",
  "address": "644 Ponte Ryan Esteves",
  "city": "São José da Coroa Grande",
  "state": "Rondônia",
  "doctor": {
   "crm": "B00067668W",
   "crm_state": "RS",
   "name": "Félix Garcês",
   "email": "letty_greenfelder@herzog.name"
  }
 }
]
```

- `GET /api/test/:token` - Exibe mais detalhes sobre um token de exame, incluindo todos os resultados dos testes desse exame.

Exemplo de resposta:
```json
{
 "result_token": "00S0MD",
 "result_date": "2022-03-03",
 "cpf": "099.204.552-53",
 "name": "Ladislau Duarte",
 "email": "lisha@rosenbaum.org",
 "birthday": "1981-02-02",
 "address": "s/n Marginal Pietro",
 "city": "Peritiba",
 "state": "Rio Grande do Norte",
 "doctor": {
  "crm": "B000BJ8TIA",
  "crm_state": "PR",
  "name": "Ana Sophia Aparício Neto",
  "email": "corene.hane@pagac.io"
 },
 "tests": [
  {
   "type": "hemácias",
   "limits": "45-52",
   "result": "45"
  },
  {
   "type": "leucócitos",
   "limits": "9-61",
   "result": "82"
  },
  {
   "type": "plaquetas",
   "limits": "11-93",
   "result": "25"
  }
 ]
}

```
## Como rodar os testes
Para executar somente o container de testes da aplicação, execute o comando abaixo, que também executa a verificação do Rubocop:
```
docker compose up test
```

## Como visualizar o dashboard dos Jobs
Para visualizar o painel de processos do Sidekiq, enquanto a aplicação principal está funcionando, rode em outro terminal os seguintes comandos:
 ```
 docker exec -it myapp bash
 bundle exec puma sidekiq_web.ru
 ```

 O painel deve estar disponivel em:
 ```
 http://localhost:9292/
 ```

## Casos de teste
![](https://github.com/user-attachments/assets/829591a5-3717-49b2-bd68-a4a184631654)
Tela inicial que exibe a listagem de todos os tokens de exames.

![](https://github.com/user-attachments/assets/7c82db41-7343-40ee-817c-03ae7024ab9d)
Tela de detalhes de um token de exame, com uma tabela exibindo todos os seus resultados.

![](https://github.com/user-attachments/assets/68d839fb-eba6-4080-9202-b3dc14d9ac9a)
Modal para importação de novos dados de exames via arquivo CSV. É fornecido um modelo de arquivo para auxiliar o usuário a inserir os dados de maneira correta e evitar erros de processamento.

