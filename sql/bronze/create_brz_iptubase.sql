-- iptubase
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_iptubase (
    j01_matric INTEGER,
    j01_numcgm INTEGER,
    j01_idbql INTEGER,
    j01_baixa DATE,
    j01_codave INTEGER,
    j01_fracao DOUBLE,
    j01_vagas INTEGER,
    j01_tipo_contribuinte INTEGER
) WITH (format = 'PARQUET');