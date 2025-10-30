
tabela:
CREATE TABLE IF NOT EXISTS iceberg.sefaz_niteroi_bronze.latency_tracker (
    id STRING,                  -- Identificador único do registro (ex: PK da tabela original)
    table_name STRING,          -- Nome da tabela bronze onde o dado foi inserido
    source_timestamp TIMESTAMP, -- Timestamp da alteração no PostgreSQL (vem do Debezium)
    bronze_timestamp TIMESTAMP, -- Timestamp de quando o dado foi escrito na Bronze Iceberg
    latency_ms BIGINT           -- Diferença em milissegundos
);