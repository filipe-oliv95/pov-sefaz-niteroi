-- PRIMARY_KEYS: nenhum
-- j21_matric = J01_matric da tabela iptubase

-- iptucalv
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_iptucalv (
    j21_anousu INTEGER,
    j21_matric INTEGER,
    j21_receit INTEGER,
    j21_valor DOUBLE,
    j21_quant DOUBLE,
    j21_codhis BIGINT,
    __op VARCHAR,
    __src_ts_ms BIGINT,
    __latency_ms BIGINT,
    __brz_ts_ms BIGINT,
    __brz_ts_iso VARCHAR
) WITH (format = 'PARQUET');