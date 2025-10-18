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
    j43_codbairro INTEGER
) WITH (format = 'PARQUET');