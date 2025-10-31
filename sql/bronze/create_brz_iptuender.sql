-- PRIMARY_KEYS: j43_matric
-- j43_matric = J01_matric da tabela iptubase

-- iptuender
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_iptuender (
    j43_matric INTEGER,
    j43_dest VARCHAR,
    j43_ender VARCHAR,
    j43_numimo INTEGER,
    j43_comple CHAR,
    j43_bairro VARCHAR,
    j43_munic VARCHAR,
    j43_uf CHAR(2),
    j43_cep CHAR(8),
    j43_cxpost INTEGER,
    j43_codigo INTEGER,
    j43_codbairro INTEGER,
    __op VARCHAR,
    __src_ts_ms BIGINT,
    __src_ts_iso VARCHAR,
    __brz_ts_ms BIGINT,
    __brz_ts_iso VARCHAR,
    __latency_ms BIGINT
) WITH (format = 'PARQUET');