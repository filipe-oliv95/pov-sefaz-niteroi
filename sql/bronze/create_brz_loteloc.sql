-- loteloc
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_loteloc (
    j06_idbql INTEGER,
    j06_setorloc INTEGER,
    j06_quadraloc VARCHAR,
    j06_lote VARCHAR
) WITH (format = 'PARQUET');