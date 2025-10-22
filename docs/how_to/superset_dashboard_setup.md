critérios para flags:
** flag_valor_iptu_invalida: null ou negativo
    consideramos que existem pessoas que são isentas de iptu (valor_iptu = 0)
** flag_area_construida_invalida: null ou negativo
    consideramos que existem lotes sem área construída (area_construida = 0)
** flag_tx_matric_invalida: null ou 0 ou negativo
** bairro_geo: join com slv_lotes_enriquecido

colunas:
tx_insct | bairro_geo | flag_tx_matric_invalida | flag_valor_iptu_invalida | flag_area_construida_invalida

o que fizemos:
- definimos critérios para as flags
- criamos uma view gold para inconsistencias cadastrais
- criamos um dataset a partir dele no sql lab agrupando as inconsistencias
- geramos o dataset

pegadinhas:
- numero como % (cast double)

```sql
    CAST(
        SUM(
            CASE
                WHEN flag_valor_iptu_invalida = 1
                    OR flag_area_construida_invalida = 1
                    OR flag_tx_matric_invalida = 1
                THEN 1
            ELSE 0
            END
        ) AS DOUBLE
    ) / COUNT(*)
```