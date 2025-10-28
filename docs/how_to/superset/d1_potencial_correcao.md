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
- **Dimensão**: `bairro_geo`  
- **Filtro**: `potencial_discrepancia >= 0`  
- **Limite de linhas**: `10`

**Personalizações**:
- **Título do gráfico**: *vazio*  
- **Eixo X**:
  - Título da margem: `15`
  - Rotação dos rótulos: `45°`
- **Eixo Y**:
  - Título: `Top 10 Bairros em Potencial de Correção`
  - Margem do título: `50`
  - Posição do título: `TOP`
- **Opções do gráfico**:
  - Ordenação das séries por: `total value`
  - Exibir valor: `true`