# PoV Secretaria de Fazenda de Niterói

Este repositório contém a implementação da prova de conceito (PoV) de integração de dados geoespaciais e cadastros imobiliários na plataforma de dados **TDP (Tecnisys Data Platform)**.

## Estrutura do Projeto

- `conf/` – Configurações de serviços (Postgres, Kafka Connect, Spark, Superset etc.)
- `data/` – Dados brutos e processados (geo, CDC, amostras)
- `infra/` – Scripts de infraestrutura (HDFS, Trino)
- `jobs/` – Jobs de ingestão e transformação (NiFi, Python)
- `sql/` – Scripts DDL/DML para camadas bronze, silver e gold
- `src/` – Código fonte complementar (Ranger, Superset)
- `tests/` – Validações de dados e testes

## Próximos passos

1. **[Configuração Inicial da Plataforma](docs/SETUP.md)** – Verifique pré-requisitos e configure os serviços.
2. **[Execução do Pipeline End-to-End](docs/PIPELINE.md)** – Passo a passo para rodar a PoV.
3. **[Resultados da PoV](docs/RESULTS.md)** – KPIs atingidos, evidências e lições aprendidas.

> 💡 Este projeto depende de uma instância do **TDP com os seguintes serviços ativos**:  
> HDFS, YARN, MapReduce, Hive, HBase, Zookeeper, Atlas, Kafka, Ranger, NiFi, Spark 3, Superset, Trino.