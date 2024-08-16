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

