# Configuração Inicial da Plataforma

Antes de executar o pipeline, certifique-se de que o ambiente TDP está devidamente configurado.

## Serviços Necessários (devem estar **ativos** no TDP via Ambari)

- HDFS
- YARN
- MapReduce
- Hive
- Zookeeper
- Kafka
- Ranger
- NiFi
- Spark 3
- Superset
- Trino

## Configurações Específicas

### 1. **PostgreSQL (Origem dos Dados)**
- Local: [`conf/postgres/postgres_setup.md`](/conf/postgres/postgres_setup.md)
- Ações:
  - Criar usuário com permissões adequadas
  - Configurar WAL (`wal_level = logical`)
  - Garantir acesso remoto (pg_hba.conf)
  - Criar database, schemas e tabelas de origem

### 2. **Kafka Connect**
- Local: [`conf/kafka_connect/kcnn_config.md`](/conf/kcnn/kcnn_config.md)
- Ações:
  - Configurar e iniciar o Kafka Connect no TDP
  - Validar conectividade com Kafka e Postgres

### 3. **Spark**
- Local: [`conf/spark/spark_config.md`](/conf/spark/spark_config.md)
- Ações:
  - Adicionar JARs geoespaciais (ex: Sedona, GeoMesa)
  - Configurar Spark para uso com dados espaciais
  - Configurar ambiente virtual antes de rodar os Scripts Spark

### 4. **Superset**
- Local: [`conf/superset/superset_config.md`](/conf/superset/superset_config.md)
- Ações:
  - Conectar ao Trino como fonte de dados
  - Configurar Mapbox API Key para mapas
  - Ajustar timeout de queries
  - Habilitar visualizações geográficas (ex: deck.gl)

### 5. **Trino**
- Local: [`conf/trino/trino_config.md`](/conf/trino/trino_config.md)
- Ações:
  - Ligar o conector com o Iceberg
  - Exportar variáveis JAVA

> **Importante**: Sem essas configurações, o pipeline **não funcionará corretamente**.
