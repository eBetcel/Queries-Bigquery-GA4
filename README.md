# Google Analytics 4 BigQuery Queries

Este repositório contém um conjunto de queries SQL para consultar a base de dados do Google Analytics 4 no BigQuery. O objetivo dessas consultas é que sirva para responder perguntas de negócio comuns a partir dos dados do GA4 e também servir de base para a montagem de queries mais avançadas.

## Pré-requisitos

Antes de utilizar as queries deste repositório, certifique-se de que você tenha os seguintes requisitos:

1. **Conta do Google Cloud**: É necessário ter uma conta no Google Cloud Platform (GCP) e ter acesso ao BigQuery.

2. **Ativar o BigQuery Export para o Google Analytics 4**: Certifique-se de que o BigQuery Export esteja ativado para o seu projeto do Google Analytics 4. Isso permitirá que os dados do GA4 sejam exportados para o BigQuery.

## Estrutura do Repositório

O repositório está organizado da seguinte maneira:

|-- queries
| |-- 01_query_exemplo.sql
| |-- 02_outra_query.sql
| |-- ...
|-- README.md


## Contribuições

Contribuições são bem-vindas! Se você tiver queries adicionais, melhorias ou correções, sinta-se à vontade para abrir um pull request.

## Avisos

- Certifique-se de compreender os custos associados à execução de queries no BigQuery, pois o uso excessivo pode resultar em encargos significativos.

- As queries fornecidas são exemplos genéricos e podem precisar ser ajustadas de acordo com as necessidades específicas do seu projeto e conjunto de dados.
