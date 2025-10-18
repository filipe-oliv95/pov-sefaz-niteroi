-- Criação da tabela de limites de bairros. A inserção dos dados é feita direto ao criar a tabela

CREATE TABLE sefaz_slv.slv_limite_de_bairros 
WITH (format = 'PARQUET')
AS
SELECT tx_bairro, border, shape_area, shape_length
FROM sefaz_brz.brz_limite_de_bairros;