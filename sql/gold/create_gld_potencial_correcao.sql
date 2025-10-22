

CREATE OR REPLACE VIEW sefaz_gld.gld_potencial_correcao AS
WITH base AS (
    SELECT
        tx_insct,
        tx_matric,
        bairro_geo,
        area_construida,
        total_construido_lote,
        shape_area,
        shape_length,
        valor_iptu,
        valor_iptu / NULLIF(area_construida, 0) AS fator_iptu_m2
    FROM sefaz_slv.slv_cadastro_lotes_unificado
    WHERE area_construida IS NOT NULL
    AND valor_iptu IS NOT NULL
),
fator_max AS (
    SELECT
        tx_insct,
        MAX(fator_iptu_m2) AS max_fator_iptu_m2
    FROM base
    GROUP BY tx_insct
),
resumo AS (
    SELECT
        b.tx_insct,
        b.tx_matric,
        b.bairro_geo,
        b.area_construida,
        b.total_construido_lote,
        b.shape_area,
        b.shape_length,
        b.valor_iptu,
        b.fator_iptu_m2,
        f.max_fator_iptu_m2,
        GREATEST(b.area_construida * f.max_fator_iptu_m2 - b.valor_iptu, 0) AS potencial_discrepancia,
        CASE 
            WHEN b.valor_iptu < b.area_construida * f.max_fator_iptu_m2 THEN TRUE
            ELSE FALSE
        END AS flag_discrepancia
    FROM base b
    INNER JOIN fator_max f
        ON b.tx_insct = f.tx_insct
)
SELECT
    tx_insct,
    tx_matric,
    bairro_geo,
    area_construida,
    total_construido_lote,
    shape_area,
    shape_length,
    valor_iptu,
    fator_iptu_m2,
    potencial_discrepancia,
    flag_discrepancia
FROM resumo;