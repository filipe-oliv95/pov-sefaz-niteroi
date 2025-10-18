-- Criação da tabela de lotes enriquecidos. A inserção dos dados será feita via script pyspark

CREATE TABLE iceberg.sefaz_slv.slv_lotes_enriquecido (
    tx_insct VARCHAR,
    tx_nroproc VARCHAR,
    tx_logrado VARCHAR,
    tx_loteame VARCHAR,
    tx_observ VARCHAR,
    globalid_1 VARCHAR,
    tx_bairro VARCHAR,
    tx_streetview VARCHAR,
    db_lng DOUBLE,
    db_lat DOUBLE,
    created_date TIMESTAMP,
    created_user VARCHAR,
    last_edited_date TIMESTAMP,
    last_edited_user VARCHAR,
    tx_zoneamento VARCHAR,
    tx_hier_via VARCHAR,
    shape_length DOUBLE,
    shape_area DOUBLE,
    db_lat_geo DOUBLE,
    db_lng_geo DOUBLE,
    bairro_geo VARCHAR,
    flag_tx_bairro_invalido INT NOT NULL,
    flag_tx_insct_invalido INT NOT NULL,
    flag_db_lat_lng_invalido INT NOT NULL,
    flag_tx_insct_duplicado INT NOT NULL,
    flag_tx_bairro_geo_inconsistente INT NOT NULL
)
WITH (
    format = 'PARQUET'
);