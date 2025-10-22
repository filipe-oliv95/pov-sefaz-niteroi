-- lotes_arcgis
CREATE TABLE iceberg.sefaz_brz.brz_lotes_arcgis (
   tx_insct varchar,
   tx_nroproc varchar,
   tx_logrado varchar,
   tx_loteame varchar,
   tx_observ varchar,
   globalid_1 varchar,
   tx_bairro varchar,
   tx_streetview varchar,
   db_lng double,
   db_lat double,
   created_date timestamp(6),
   created_user varchar,
   last_edited_date timestamp(6),
   last_edited_user varchar,
   tx_zoneamento varchar,
   tx_hier_via varchar,
   shape_length double,
   shape_area double
)
WITH (format = 'PARQUET');