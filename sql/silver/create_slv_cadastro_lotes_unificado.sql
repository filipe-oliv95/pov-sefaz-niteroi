-- Criação da view que unifica cadastro imobiliario silver e lotes arcgis silver

CREATE OR REPLACE VIEW sefaz_slv.slv_cadastro_lotes_unificado AS
WITH lotes_dedup AS (
  SELECT 
    l.*,
    ROW_NUMBER() OVER (PARTITION BY tx_insct ORDER BY tx_insct) AS rn
  FROM sefaz_slv.slv_lotes_enriquecido l
)
SELECT
  cad.tx_insct,
  cad."tx_nroport", cad."tx_complem", cad."tx_tipo_lo", cad."tx_loteloc", cad."tx_quadraloc", cad."tx_arealote",
  cad."codigo_proprietario", cad."tx_matric", cad."total_construido_lote", cad."id_construcao",
  cad."area_construida", cad."ano_iptu", cad."valor_iptu",
  lot."tx_nroproc", lot."tx_logrado", lot."tx_loteame", lot."tx_observ", lot."globalid_1", lot."tx_bairro",
  lot."tx_streetview", lot."db_lng", lot."db_lat", lot."tx_zoneamento", lot."tx_hier_via", lot."shape_length", lot."shape_area",
  lot."db_lat_geo", lot."db_lng_geo", lot."bairro_geo", lot."flag_tx_bairro_invalido",
  lot."flag_db_lat_lng_invalido", lot."flag_tx_bairro_geo_inconsistente"
FROM sefaz_slv.slv_cadastro_imobiliario cad
INNER JOIN lotes_dedup lot
  ON cad.tx_insct = lot.tx_insct
 AND lot.rn = 1;