-- PRIMARY_KEYS: j01_matric
-- j01_idbql = j34_idbql da tabela lote
-- j01_matric = J39_matric da tabela iptuconstr
-- j01_matric = J43_matric da tabela iptuender
-- j01_matric = J21_matric da tabela iptucalv

-- iptubase
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_iptubase (
    j01_matric INTEGER,
    j01_numcgm INTEGER,
    j01_idbql INTEGER,
    j01_baixa DATE,
    j01_codave INTEGER,
    j01_fracao DOUBLE,
    j01_vagas INTEGER,
    j01_tipo_contribuinte INTEGER,
    __op VARCHAR,
    __src_ts_ms BIGINT,
    __latency_ms BIGINT,
    __brz_ts_ms BIGINT,
    __brz_ts_iso VARCHAR
) WITH (format = 'PARQUET');