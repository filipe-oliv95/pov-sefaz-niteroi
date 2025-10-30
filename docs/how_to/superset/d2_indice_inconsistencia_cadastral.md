# Seção 2: Índice de Inconsistência Cadastral

## 1. Total de Cadastros  
- **Tipo de gráfico**: BigNumber  
- **Nome do gráfico**: `d2_total_cadastros`  
- **Subtítulo**: `Total de Cadastros`

---

## 2. Índice de Inconsistência Cadastral  
- **Tipo de gráfico**: BigNumber  
- **Nome do gráfico**: `d2_indice_inconsistencia_cadastral`  
- **Métrica (SQL personalizado)**:
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
- **Subtítulo**: `Índice de Inconsistência Cadastral`

---

## 3. Total de Cadastros Inconsistentes  
- **Tipo de gráfico**: BigNumber  
- **Nome do gráfico**: `d2_total_cadastros_inconsistentes`  
- **Métrica (SQL personalizado)**:
  ```sql
  SUM(
    CASE
      WHEN flag_valor_iptu_invalida = 1
        OR flag_area_construida_invalida = 1
        OR flag_tx_matric_invalida = 1
      THEN 1
      ELSE 0
    END
  )
  ```
- **Subtítulo**: `Total de Cadastros Inconsistentes`

---

## 4. Inconsistências por Categoria  
- **Tipo de gráfico**: Pie Chart  
- **Nome do gráfico**: `d2_inconsistencias_por_categoria_pie_chart`  
- **Fonte de dados (SQL personalizado)**:
  ```sql
  SELECT 'Matrícula' AS nome_flag, flag_tx_matric_invalida AS invalido
  FROM iceberg.sefaz_gld.gld_inconsistencia_cadastral

  UNION ALL

  SELECT 'Valor IPTU' AS nome_flag, flag_valor_iptu_invalida AS invalido
  FROM iceberg.sefaz_gld.gld_inconsistencia_cadastral

  UNION ALL

  SELECT 'Área Construída' AS nome_flag, flag_area_construida_invalida AS invalido
  FROM iceberg.sefaz_gld.gld_inconsistencia_cadastral
  ```
- **Dimensão**: `nome_flag`  
- **Métrica**: `SUM(invalido)`

**Personalizações**:
- **Opções do gráfico**:
  - Limiar de porcentagem: `0`
  - Tipo: `plain`
  - Orientação da legenda: `bottom`
  - Margem: `10`
- **Rótulos**:
  - Tipo: `category, value and percentage`
  - Exibir rótulos: `true`
  - Posicionar rótulos fora: `true`
  - Linha de rótulo: `true`
  - Exibir total: `true`
  - Formato: `donut`