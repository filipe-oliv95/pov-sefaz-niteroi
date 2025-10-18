
-- Criação da view que unifica as tabelas do ecidades bronze

CREATE or REPLACE VIEW sefaz_slv.slv_cadastro_imobiliario AS
WITH
  cte_cadastro_imobiliario AS (
   SELECT
     j01_numcgm codigo_proprietario
   , concat(concat(SUBSTRING(j34_setor, 2, 3), SUBSTRING(j34_quadra, 2, 3)), j34_lote) tx_insct
   , j01_matric tx_matric
   , j01_idbql idbql
   , j34_area area_lote
   , j34_totcon total_construido_lote
   FROM
     (iceberg.sefaz_brz.brz_iptubase
   INNER JOIN iceberg.sefaz_brz.brz_lote ON (j34_idbql = j01_idbql))
   WHERE (j01_baixa IS NULL)
) 
, cte_endereco AS (
   SELECT
     j43_matric
   , j43_numimo tx_nroport
   , j43_comple tx_complem
   FROM
     iceberg.sefaz_brz.brz_iptuender
) 
, cte_localizacao AS (
   SELECT
     j06_idbql idbql
   , j06_lote tx_loteloc
   , j06_quadraloc tx_quadraloc
   FROM
     iceberg.sefaz_brz.brz_loteloc
) 
, cte_tipo_lote AS (
   SELECT
     cl.j35_idbql idbql
   , ARRAY_JOIN(ARRAY_AGG(cv.j71_descr ORDER BY cv.j71_descr ASC), ', ') tx_tipo_lo
   FROM
     (iceberg.sefaz_brz.brz_carlote cl
   LEFT JOIN (
      SELECT
        j71_caract
      , j71_descr
      FROM
        (
         SELECT
           j71_caract
         , j71_descr
         , ROW_NUMBER() OVER (PARTITION BY j71_caract ORDER BY j71_anousu DESC NULLS LAST) rn
         FROM
           iceberg.sefaz_brz.brz_carvalor
      ) 
      WHERE (rn = 1)
   )  cv ON (cv.j71_caract = cl.j35_caract))
   GROUP BY cl.j35_idbql
) 
, cte_construcoes AS (
   SELECT
     MAX(j39_idcons) id_construcao
   , j39_matric
   , j39_area area_construida
   FROM
     iceberg.sefaz_brz.brz_iptuconstr
   GROUP BY j39_matric, j39_area
) 
, cte_valor_iptu AS (
   SELECT
     j21_matric
   , j21_anousu ano_iptu
   , SUM(j21_valor) valor_iptu
   FROM
     iceberg.sefaz_brz.brz_iptucalv
   WHERE ((j21_anousu = 2025) AND (j21_codhis = 1))
   GROUP BY j21_matric, j21_anousu
) 
SELECT
  cci.tx_insct
, en.tx_nroport
, en.tx_complem
, tl.tx_tipo_lo
, loc.tx_loteloc
, loc.tx_quadraloc
, cci.area_lote tx_arealote
, cci.codigo_proprietario
, cci.tx_matric
, cci.total_construido_lote
, cc.id_construcao
, cc.area_construida
, cv.ano_iptu
, cv.valor_iptu
FROM
  (((((cte_cadastro_imobiliario cci
LEFT JOIN cte_endereco en ON (en.j43_matric = cci.tx_matric))
LEFT JOIN cte_localizacao loc ON (loc.idbql = cci.idbql))
LEFT JOIN cte_tipo_lote tl ON (tl.idbql = cci.idbql))
LEFT JOIN cte_construcoes cc ON (cc.j39_matric = cci.tx_matric))
LEFT JOIN cte_valor_iptu cv ON (cv.j21_matric = cci.tx_matric));