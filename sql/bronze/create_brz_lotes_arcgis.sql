-- lotes_arcgis
CREATE TABLE iceberg.sefaz_brz.brz_lotes_arcgis (
   j34_idbql integer,
   j34_setor varchar,
   j34_quadra varchar,
   j34_lote varchar,
   j34_area double,
   j34_bairro integer,
   j34_areal double,
   j34_totcon double,
   j34_zona bigint,
   j34_quamat integer,
   j34_areapreservada double,
    __op VARCHAR,
    __ts_ms BIGINT,
    __ts_iso VARCHAR
)
WITH (
   format = 'PARQUET'
);