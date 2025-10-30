# Seção 1: Potencial de Correção

## 1. Receita Atual de Arrecadação  
- **Tipo de gráfico**: BigNumber  
- **Fonte de dados**: `sefaz_gld.gld_potencial_correcao`  
- **Nome do gráfico**: `d1_receita_arrecadacao_atual`  
- **Métrica**: `SUM(valor_iptu)`  
- **Subtítulo**: `Receita de Arrecadação Atual`

---

## 2. Receita Potencial Total  
- **Tipo de gráfico**: BigNumber  
- **Fonte de dados**: `sefaz_gld.gld_potencial_correcao`  
- **Nome do gráfico**: `d1_receita_potencial_total`  
- **Métrica**: `SUM(potencial_discrepancia)`  
- **Subtítulo**: `Receita Potencial Total`

---

## 3. Receita Potencial Percentual  
- **Tipo de gráfico**: BigNumber  
- **Fonte de dados**: `sefaz_gld.gld_potencial_correcao`  
- **Nome do gráfico**: `d1_receita_potencial_percentual`  
- **Métrica (SQL personalizado)**:
  ```sql
  SUM(potencial_discrepancia) / SUM(valor_iptu)
  ```
- **Subtítulo**: `Receita Potencial Percentual`  
- **Formatação do número**: `, .1%`

---

## 4. Top 10 Bairros por Potencial de Correção  
- **Tipo de gráfico**: Bar Chart  
- **Fonte de dados**: `sefaz_gld.gld_potencial_correcao`  
- **Nome do gráfico**: `d1_top_bairros_pot_correcao`  
- **X-axis**: `bairro_geo`  
- **X-axis sort by**: `SUM(bairro_geo)`
- **X-axis sort ascending**: `false`
- **Metrics**: `SUM(potencial_discrepancia)`
- **Filtro**: `potencial_discrepancia >= 0`  
- **Limite de linhas**: `10`

**Personalizações**:
- **Título do gráfico**: *vazio*  
- **Eixo X**:
  - Título da margem: `15`
- **Eixo Y**:
  - Margem do título: `50`
  - Posição do título: `TOP`
- **Opções do gráfico**:
  - Ordenação das séries por: `total value`
  - Rotação dos rótulos: `45°`
  - Exibir valor: `true`
  - Exibir legenda: `false`

## 5. 
- **Tipo de gráfico**: Table
- **Fonte de dados**: `sefaz_gld.gld_potencial_correcao`  
- **Nome do gráfico**: `d1_ranking_candidatos_correcao_por_lote`  
- **Dimensão**: 
  - `tx_insct` como `Inscrição Técnica`
  - `tx_matric` como `Matícula`
  - `potencial_discrepancia` como `Potencial de Correção`
  - `area_construida` como `Área Construída (m²)`
  - `valor_iptu` como `Valor do IPTU (R$)`
  - `fator_iptu_m2` como `IPTU/m²`
- **Time Grain**: `Day`
- **Sort by**: `SUM(potencial_discrepancia)`
- **Server Pagination**: `true`
- **Server Page Length**: 20
- **Sort descending**: `true`

**Personalizações**:
- **Search Box**: `true`
- **Cell Bars**: `true`
- **Color +/-**: `true`

