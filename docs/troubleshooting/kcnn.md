
### **1. Teste inicial em ambiente controlado (VM local)**
- **Resultado**: **Sucesso total**.
  - O conector Debezium foi criado com `snapshot.mode=initial`.
  - Realizou **snapshot completo** de todas as tabelas configuradas (`iptubase`, `lote`, etc.).
  - **Tópicos Kafka foram criados e populados corretamente** com os dados existentes.

---

### **2. Primeira tentativa no ambiente de PoC (servidores reais)**
- **Resultado**: **Funcionou parcialmente**, mas **falhou por falta de espaço em disco**.
  - O snapshot foi iniciado e os tópicos começaram a ser populados.
  - **O Kafka esgotou espaço em disco** no diretório padrão (`/`), interrompendo o processo.

---

### **3. Correção de infraestrutura**
- **Ação**: Alterado o diretório de armazenamento do Kafka para `/mnt/Kafka-logs`.
  - Motivo: os discos raiz (`/`) dos **Workers estavam 100% cheios**.
  - Essa mudança liberou espaço suficiente para armazenar os logs do Kafka.

---

### **4. Erro ao criar o conector debezium**
- **Ação**: Apagados os tópicos principais do kafka via zookeeper para o kafka recriá-los com o broker id correto
---

### **5. Nova tentativa após correção (versão atualizada do conector)**
- **Resultado**: **Falha silenciosa**.
  - Conector foi criado com sucesso.
  - **Tópicos Kafka não foram criados**.
  - Log mostra apenas: `flushing messages offsets 0`.
  - **Nenhum erro explícito** no log do Kafka Connect.
  - Não aparece snapshot SUCCESS ou SKIPED

---

### **5. Tentativa de reutilizar a versão funcional (item 2)**
- **Resultado**: **Conflito de recursos no PostgreSQL**.
  - Erro: **replication slot já existente** (`slot already exists`).
  - Isso ocorreu porque o conector anterior não foi limpo corretamente.

---

### **6. Limpeza e novos testes**
- **Ações realizadas**:
  - **Slots de replicação** antigos removidos via `pg_drop_replication_slot()`.
  - **Publicações** antigas removidas via `DROP PUBLICATION`.
  - Novos conectores criados com nomes, slots e publicações versionados (ex: `v7`, `v8`, `v10`).
- **Resultado**: **Mesmo comportamento**.
  - Tópicos **NÃO** são criados.
  - **Nenhum dado é produzido**.
  - Log continua mostrando `flushing messages 0` e **snapshot sendo SKIPPED ou COMPLETED sem efeito visível**.

---

### 📌 **Diagnóstico atual**

#### ✅ **O que está correto**
- Configuração do PostgreSQL:
  - `wal_level = logical`
  - Usuário com permissões de `REPLICATION` e `SELECT`
  - Publicações e slots criados corretamente pelo debezium
- Configuração do conector Debezium:
  - `snapshot.mode=initial`
  - `table.include.list` e `snapshot.include.collection.list` definidos
  - `topic.prefix` e `database.server.name` versionados

#### ⚠️ **Diferenças críticas entre ambientes**
| Item | VM Local | Ambiente PoC |
|------|--------|-------------|
| **Topologia** | 1 nó | 4 nós |
| **Volume de dados** | Pequeno | **Grande** (tabelas com milhões de linhas) |
| **Desempenho do PostgreSQL** | Rápido | **Lento** (I/O, CPU ou memória limitada) |
| **Comportamento do snapshot** | Completo e visível | **Iniciado, mas sem mensagens visíveis no Kafka** |

---

### 🔍 **Hipóteses mais prováveis para o problema atual**

1. **Snapshot está sendo executado, mas falha silenciosamente durante a leitura das tabelas**  
   → Possivelmente por **timeout de socket** ou **erro de serialização**.

4. **O PostgreSQL está tão lento que o snapshot demora horas**, e você está verificando cedo demais.