-- Etapa 1: Configurar sessão
SET SESSION distinct_aggregations_strategy = 'single_step';

-- Etapa 2: Criar a view
CREATE OR REPLACE VIEW iceberg.sefaz_slv.slv_cadastro_imobiliario AS
WITH
iptubase_latest AS (
  SELECT b.*
  FROM iceberg.sefaz_brz.brz_iptubase b
  JOIN (
    SELECT j01_matric, MAX(__ts_ms) AS max_ts
    FROM iceberg.sefaz_brz.brz_iptubase
    GROUP BY j01_matric
  ) l ON b.j01_matric = l.j01_matric AND b.__ts_ms = l.max_ts
  WHERE COALESCE(b.__op, '') <> 'DELETE'
),
lote_latest AS (
  SELECT b.*
  FROM iceberg.sefaz_brz.brz_lote b
  JOIN (
    SELECT j34_idbql, MAX(__ts_ms) AS max_ts
    FROM iceberg.sefaz_brz.brz_lote
    GROUP BY j34_idbql
  ) l ON b.j34_idbql = l.j34_idbql AND b.__ts_ms = l.max_ts
  WHERE COALESCE(b.__op, '') <> 'DELETE'
),
loteloc_latest AS (
  SELECT b.*
  FROM iceberg.sefaz_brz.brz_loteloc b
  JOIN (
    SELECT j06_idbql, MAX(__ts_ms) AS max_ts
    FROM iceberg.sefaz_brz.brz_loteloc
    GROUP BY j06_idbql
  ) l ON b.j06_idbql = l.j06_idbql AND b.__ts_ms = l.max_ts
  WHERE COALESCE(b.__op, '') <> 'DELETE'
),
iptuender_latest AS (
  SELECT b.*
  FROM iceberg.sefaz_brz.brz_iptuender b
  JOIN (
    SELECT j43_matric, MAX(__ts_ms) AS max_ts
    FROM iceberg.sefaz_brz.brz_iptuender
    GROUP BY j43_matric
  ) l ON b.j43_matric = l.j43_matric AND b.__ts_ms = l.max_ts
  WHERE COALESCE(b.__op, '') <> 'DELETE'
),
iptuconstr_latest AS (
  SELECT
    j39_matric,
    j39_idcons,
    j39_area,
    __ts_ms
  FROM (
    SELECT
      c.*,
      ROW_NUMBER() OVER (PARTITION BY j39_matric, j39_idcons ORDER BY __ts_ms DESC) AS __rn
    FROM iceberg.sefaz_brz.brz_iptuconstr c
    WHERE COALESCE(c.__op, '') <> 'DELETE'
  )
  WHERE __rn = 1
),
iptuconstr_one_per_matric AS (
  SELECT
    j39_matric,
    j39_idcons,
    j39_area,
    __ts_ms
  FROM (
    SELECT
      c.*,
      ROW_NUMBER() OVER (PARTITION BY j39_matric ORDER BY __ts_ms DESC, j39_idcons DESC) AS __rn
    FROM iptuconstr_latest c
  )
  WHERE __rn = 1
),
carlote_latest AS (
  SELECT
    j35_idbql,
    j35_caract,
    __ts_ms
  FROM (
    SELECT
      cl.*,
      ROW_NUMBER() OVER (PARTITION BY j35_idbql, j35_caract ORDER BY __ts_ms DESC) AS __rn
    FROM iceberg.sefaz_brz.brz_carlote cl
    WHERE COALESCE(cl.__op, '') <> 'DELETE'
  )
  WHERE __rn = 1
),
carvalor_latest_per_caract AS (
  SELECT
    j71_caract,
    j71_descr,
    j71_anousu,
    __ts_ms
  FROM (
    SELECT
      cv.*,
      ROW_NUMBER() OVER (PARTITION BY j71_caract ORDER BY j71_anousu DESC NULLS LAST, __ts_ms DESC) AS __rn
    FROM iceberg.sefaz_brz.brz_carvalor cv
    WHERE COALESCE(cv.__op, '') <> 'DELETE'
  )
  WHERE __rn = 1
),
iptucalv_2025 AS (
  SELECT
    j21_matric,
    j21_anousu,
    SUM(j21_valor) AS valor_iptu
  FROM iceberg.sefaz_brz.brz_iptucalv
  WHERE COALESCE(__op, '') <> 'DELETE'
    AND j21_anousu = 2025
    AND j21_codhis = 1
  GROUP BY j21_matric, j21_anousu
),
cte_cadastro_imobiliario AS (
  SELECT
    ib.j01_numcgm AS codigo_proprietario,
    SUBSTRING(lt.j34_setor, 2, 3) || SUBSTRING(lt.j34_quadra, 2, 3) || lt.j34_lote AS tx_insct,
    ib.j01_matric AS tx_matric,
    ib.j01_idbql AS idbql,
    lt.j34_area AS area_lote,
    lt.j34_totcon AS total_construido_lote
  FROM iptubase_latest ib
  JOIN lote_latest lt ON lt.j34_idbql = ib.j01_idbql
  WHERE ib.j01_baixa IS NULL
),
cte_endereco AS (
  SELECT
    j43_matric,
    j43_numimo AS tx_nroport,
    j43_comple AS tx_complem
  FROM iptuender_latest
),
cte_localizacao AS (
  SELECT
    j06_idbql AS idbql,
    j06_lote AS tx_loteloc,
    j06_quadraloc AS tx_quadraloc
  FROM loteloc_latest
),
cte_tipo_lote AS (
  SELECT
    cl.j35_idbql AS idbql,
    ARRAY_JOIN(ARRAY_AGG(cv.j71_descr ORDER BY cv.j71_descr), ', ') AS tx_tipo_lo
  FROM carlote_latest cl
  LEFT JOIN carvalor_latest_per_caract cv ON cv.j71_caract = cl.j35_caract
  GROUP BY cl.j35_idbql
),
cte_construcoes AS (
  SELECT
    j39_idcons AS id_construcao,
    j39_matric,
    j39_area AS area_construida
  FROM iptuconstr_one_per_matric
)
SELECT
  cci.tx_insct,
  en.tx_nroport,
  en.tx_complem,
  tl.tx_tipo_lo,
  loc.tx_loteloc,
  loc.tx_quadraloc,
  cci.area_lote AS tx_arealote,
  cci.codigo_proprietario,
  cci.tx_matric,
  cci.total_construido_lote,
  cc.id_construcao,
  cc.area_construida,
  cv.j21_anousu AS ano_iptu,
  cv.valor_iptu
FROM cte_cadastro_imobiliario cci
LEFT JOIN cte_endereco en ON en.j43_matric = cci.tx_matric
LEFT JOIN cte_localizacao loc ON loc.idbql = cci.idbql
LEFT JOIN cte_tipo_lote tl ON tl.idbql = cci.idbql
LEFT JOIN cte_construcoes cc ON cc.j39_matric = cci.tx_matric
LEFT JOIN iptucalv_2025 cv ON cv.j21_matric = cci.tx_matric;