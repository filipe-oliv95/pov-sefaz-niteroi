-- PRIMARY_KEYS: j39_matric, j39_idcons
-- j39_matric = J01_matric da tabela iptubase

-- iptuconstr
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_iptuconstr (
    j39_matric INTEGER,
    j39_idcons INTEGER,
    j39_ano INTEGER,
    j39_area DOUBLE,
    j39_areap DOUBLE,
    j39_dtlan DATE,
    j39_codigo INTEGER,
    j39_numero INTEGER,
    j39_compl VARCHAR,
    j39_dtdemo DATE,
    j39_idaument INTEGER,
    j39_idprinc BOOLEAN,
    j39_habite DATE,
    j39_pavim INTEGER,
    j39_codprotdemo VARCHAR,
    j39_obs VARCHAR,
    j39_areajirau INTEGER,
    j39_areamezanino INTEGER,
    j39_areajiraudeposito INTEGER,
    __op VARCHAR,
    __src_ts_ms BIGINT,
    __src_ts_iso VARCHAR,
    __brz_ts_ms BIGINT,
    __brz_ts_iso VARCHAR,
    __latency_ms BIGINT
) WITH (format = 'PARQUET');