-- PRIMARY_KEYS: j06_idbql
-- j06_idbql = j34_idbql da tabela lote

-- loteloc
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_loteloc (
    j06_idbql INTEGER,
    j06_setorloc INTEGER,
    j06_quadraloc VARCHAR,
    j06_lote VARCHAR,
    __op VARCHAR,
    __src_ts_ms BIGINT,
    __src_ts_iso VARCHAR,
    __brz_ts_ms BIGINT,
    __brz_ts_iso VARCHAR,
    __latency_ms BIGINT
) WITH (format = 'PARQUET');