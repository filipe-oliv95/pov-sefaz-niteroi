-- iptucalv
CREATE TABLE IF NOT EXISTS iceberg.sefaz_brz.brz_iptucalv (
    j21_anousu INTEGER,
    j21_matric INTEGER,
    j21_receit INTEGER,
    j21_valor DOUBLE,
    j21_quant DOUBLE,
    j21_codhis BIGINT
) WITH (format = 'PARQUET');