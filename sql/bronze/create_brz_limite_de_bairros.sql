-- limite_de_bairros
CREATE TABLE iceberg.sefaz_brz.brz_limite_de_bairros (
   tx_bairro varchar,
   border varchar,
   shape_area double,
   shape_length double,
   tx_legislacao varchar
)
WITH (format = 'PARQUET');