-- carvalor
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_carvalor (
    j71_codigo INTEGER,
    j71_anousu INTEGER,
    j71_caract INTEGER,
    j71_descr VARCHAR,
    j71_valor DOUBLE,
    j71_ini DOUBLE,
    j71_fim DOUBLE,
    j71_quantini DOUBLE,
    j71_quantfim DOUBLE
) WITH (format = 'PARQUET');