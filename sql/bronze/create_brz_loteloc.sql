-- PRIMARY_KEYS: j06_idbql
-- j06_idbql = j34_idbql da tabela lote

-- loteloc
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_loteloc (
    j06_idbql INTEGER,
    j06_setorloc INTEGER,
    j06_quadraloc VARCHAR,
    j06_lote VARCHAR,
    __op VARCHAR,
    __ts_ms BIGINT,
    __ts_iso VARCHAR
) WITH (format = 'PARQUET');