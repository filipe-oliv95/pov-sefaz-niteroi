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
    j34_areapreservada DOUBLE
) WITH (format = 'PARQUET');