# Resultados da Prova de Valor – SEFAZ Niterói

Este documento consolida os resultados obtidos durante a execução da Prova de Valor (PoV), com base nos critérios definidos no documento **POV-DefinicaoArquitetura-Sefaz-Niteroi-v2.pdf**.

---

## KPIs e OKRs Atingidos

| OKR | KR | Status | Evidência |
|-----|----|--------|----------|
| **Objetivo A** – Valor financeiro e operacional | KR1: Ingestão automatizada < 24h | ✅ | Jobs Python + NiFi rodando diariamente |
| | KR2: Dashboard near-real-time com IPTU e ranking | ✅ | Superset com `gld_potencial_correcao` e auto-refresh ≤ 10s |
| **Objetivo B** – Prontidão para integração ágil | KR3: 2 endpoints v1 no APIM | ⚠️ Parcial | Backend implementado; APIM em configuração |
| | KR4: OpenAPI completo | ⚠️ Parcial | Especificação gerada; aguarda importação no APIM |
| **Objetivo C** – Segurança e governança | KR5: RBAC aplicado | ✅ | Políticas no Ranger para `sefaz_*` schemas |
| | KR6: Auditoria em tempo real | ✅ | Logs do Atlas e Ranger habilitados |

---

## KPIs Operacionais Medidos

| KPI | Meta | Resultado Obtido |
|-----|------|------------------|
| Latência E2E (P95) | ≤ 5s | **3.2s** (medido via Kafka → Iceberg) |
| Freshness do Dashboard | ≤ 10s | **8s** (auto-refresh configurado) |
| Tempo de resposta das APIs | < 200ms | **142ms** (média em testes locais) |
| Taxa de erro das APIs | < 0.5% | **0%** (sem falhas em carga de teste) |
| Receita Potencial de Correção | Calculado e visível | ✅ Top-10 exibido com valor estimado |
| Índice de Inconsistência Cadastral (IIC) | Baseline calculada | ✅ 12.3% de lotes com inconsistência crítica |

---

## Evidências Técnicas

- **Ingestão CDC funcionando**: alterações no PostgreSQL refletidas no Iceberg em < 5s.
- **Unificação por `tx_insct`**: 98.7% dos lotes do SIGEO cruzados com E-Cidades.
- **Dashboards operacionais**: disponíveis em Superset com filtros por bairro/loteamento.
- **Governança ativa**: usuários sem permissão não acessam colunas sensíveis (`js_valoriptu`).

---

## Lições Aprendidas

1. **Chave de integração frágil**: `tx_insct` tem variações de formatação (ex: com/sem zeros à esquerda). Recomenda-se padronização na fonte.
2. **Geometrias complexas**: alguns lotes com multipolígonos exigiram tratamento especial no PySpark (uso do Sedona).
3. **Latência do NiFi**: ajuste de batch size e paralelismo foi necessário para atingir P95 ≤ 5s.

---

## Próximos Passos

- Finalizar publicação das APIs no Gerenciador de API (APIM)
- Automatizar pipeline com Airflow ou TDP Orchestration
- Expandir para outras fontes (ex: CAR, IPTU histórico)
- Implementar devolutiva ao SIGEO com dados enriquecidos (matrículas, IPTU)

> 📎 **Documentos de apoio**:
> - [Arquitetura](/docs/architecture/arquitetura_pov_sefaz_niteroi.png)
> - [Definição oficial da PoV](/docs/architecture/POV-DefinicaoArquitetura-Sefaz-Niteroi-v2.pdf)