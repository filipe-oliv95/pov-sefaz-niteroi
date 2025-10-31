-- PRIMARY_KEYS: j35_idbql, j35_caract
-- j35_caract = j34_idbql da tabela lote
-- carlote
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_carlote (
    j35_idbql INTEGER,
    j35_caract INTEGER,
    j35_dtlanc DATE,
    __op VARCHAR,
    __src_ts_ms BIGINT,
    __src_ts_iso VARCHAR,
    __brz_ts_ms BIGINT,
    __brz_ts_iso VARCHAR,
    __latency_ms BIGINT
) WITH (format = 'PARQUET');