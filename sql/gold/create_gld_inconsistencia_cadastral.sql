CREATE OR REPLACE VIEW sefaz_gld.gld_inconsistencia_cadastral AS
SELECT
    ci.tx_insct,
    ci.tx_matric,
    ci.valor_iptu,
    ci.area_construida,
    l.bairro_geo,
    CASE
        WHEN ci.tx_matric IS NULL OR ci.tx_matric <= 0 THEN 1
        ELSE 0
    END AS flag_tx_matric_invalida,
    CASE
        WHEN ci.valor_iptu IS NULL OR ci.valor_iptu < 0 THEN 1
        ELSE 0
    END AS flag_valor_iptu_invalida,
    CASE
        WHEN ci.area_construida IS NULL OR ci.area_construida < 0 THEN 1
        ELSE 0
    END AS flag_area_construida_invalida
FROM
    sefaz_slv.slv_cadastro_imobiliario ci
LEFT JOIN (
    SELECT
        tx_insct,
        -- Pega um único bairro_geo por tx_insct (evita duplicação)
        MAX(bairro_geo) AS bairro_geo  -- ou MIN, ou qualquer valor representativo
    FROM sefaz_slv.slv_lotes_enriquecido
    GROUP BY tx_insct
) l ON ci.tx_insct = l.tx_insct;



select count(*) from sefaz_gld.gld_inconsistencia_cadastral where flag_valor_iptu_invalida = 1;
select count(*) from sefaz_slv.slv_cadastro_imobiliario;
select * from sefaz_slv.slv_cadastro_imobiliario;

select count(*) from sefaz_gld.gld_inconsistencia_cadastral;



SELECT COUNT(DISTINCT tx_matric) AS qtd_tx_matric_unicas
FROM sefaz_slv.slv_cadastro_imobiliario;

