-- PRIMARY_KEYS: j34_idbql
-- j34_idbql = j01_idbql da tabela iptubase
-- j34_idbql = j35_caract da tabela carlote
-- j34_idbql = j06_codigo da tabela loteloc

-- lote
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_lote (
    j34_idbql INTEGER,
    j34_setor CHAR(4),
    j34_quadra CHAR(4),
    j34_lote CHAR(4),
    j34_area DOUBLE,
    j34_bairro INTEGER,
    j34_areal DOUBLE,
    j34_totcon DOUBLE,
    j34_zona BIGINT,
    j34_quamat INTEGER,
    j34_areapreservada DOUBLE,
    __op VARCHAR,
    __src_ts_ms BIGINT,
    __src_ts_iso VARCHAR,
    __brz_ts_ms BIGINT,
    __brz_ts_iso VARCHAR,
    __latency_ms BIGINT
) WITH (format = 'PARQUET');