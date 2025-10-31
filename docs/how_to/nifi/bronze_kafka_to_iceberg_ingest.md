# Fluxo Completo

## 1. ConsumeKafkaTopics  
**Descrição**: Consome tópicos do Kafka.  
**Pré-requisito**: O Debezium deve estar configurado corretamente, criando os tópicos com os nomes esperados.

**Properties**:  
- Kafka Brokers: `Worker-Node01.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:6667`  
- Topic Name(s): `ecidades.cadastro.carlote, ecidades.cadastro.iptubase, ecidades.cadastro.lote, ecidades.cadastro.iptuender, ecidades.cadastro.loteloc, ecidades.cadastro.iptuconstr, ecidades.cadastro.iptucalv, ecidades.cadastro.carvalor`  
- Topic Name Format: `names`  
- Value Record Reader: `JsonTreeReader`  
- Record Value Writer: `JsonRecordSetWriter`  
- Group ID: `nifi-consumer`  
- Output Strategy: `Use Content as Value`  
- Key Attribute Encoding: `UTF-8 Encoded`

**Saída**: FlowFiles em formato JSON no formato original do tópico Kafka (JSON do Debezium). Eventualmente, múltiplas mensagens podem ser agrupadas em um único FlowFile.

**Conexão**: item 2 (success)

---

## 2. SplitJson  
**Descrição**: Divide as mensagens recebidas do ConsumeKafkaTopics em JSONs individuais.

**Properties**:  
- JsonPath Expression: `$[*]`  
- Null Value Representation: `empty string`  
- Max String Length: `20 MB`

**Saída**: Um FlowFile por mensagem JSON.

**Conexão**: item 3 (split)

---

## 3. EvaluateJsonPath  
**Descrição**: Extrai o tipo de operação (`op`) e o timestamp de origem (`ts_ms`) de cada mensagem Kafka.

**Properties**:  
- Destination: `flowfile-attribute`  
- Return Type: `auto-detect`  
- Path Not Found Behavior: `warn`  
- Null Value Representation: `empty string`  
- Max String Length: `20 MB`  
- op: `$.op`  
- source_timestamp: `$.ts_ms`

**Conexão**: item 4 (matched)

---

## 4. EvaluateJsonPath  
**Descrição**: Extrai os campos `before` e `after` da mensagem Kafka como strings JSON.

**Properties**:  
- Destination: `flowfile-attribute`  
- Return Type: `json`  
- Path Not Found Behavior: `warn`  
- Null Value Representation: `empty string`  
- Max String Length: `20 MB`  
- after_json: `$.after`  
- before_json: `$.before`

**Conexão**: item 5 (matched)

---

## 5. RouteOnAttribute  
**Descrição**: Define rotas com base no tipo de operação: INSERT (`c`), UPDATE (`u`) ou DELETE (`d`).

**Properties**:  
- Routing Strategy: `Route to Property name`  
- DELETE: `${op:equals('d')}`  
- INSERT: `${op:equals('c')}`  
- UPDATE: `${op:equals('u')}`

**Conexão**:  
- INSERT e unmatched → item 6.1  
- UPDATE → item 6.2  
- DELETE → item 6.3

---

## 6.1 UpdateAttribute  
**Descrição**: Define atributos para operações de INSERT ou unmatched.

**Properties**:  
- content: `${after_json}`  
- operation_type: `INSERT`

**Conexão**: item 7.1 (success)

---

## 6.2 UpdateAttribute  
**Descrição**: Define atributos para operações de UPDATE.

**Properties**:  
- content: `${after_json}`  
- operation_type: `UPDATE`

**Conexão**: item 7.1 (success)

---

## 6.3 UpdateAttribute  
**Descrição**: Define atributos para operações de DELETE.

**Properties**:  
- content: `${before_json}`  
- operation_type: `DELETE`

**Conexão**: item 7.2 (success)

---

## 7.1 JsonTransformJSON  
**Descrição**: Extrai apenas o campo `after` da mensagem Debezium.

**Properties**:  
- Jolt Transformation DSL: `Chain`  
- Jolt Specification:  
  ```json
  [
    {
      "operation": "shift",
      "spec": {
        "after": "[0]"
      }
    }
  ]
  ```  
- Transform Cache Size: `1`  
- Pretty Print: `false`  
- Max String Length: `20 MB`

**Saída**: JSON contendo apenas os dados do campo `after`.

**Conexão**: item 8 (success)

---

## 7.2 JsonTransformJSON  
**Descrição**: Extrai apenas o campo `before` da mensagem Debezium.

**Properties**:  
- Jolt Transformation DSL: `Chain`  
- Jolt Specification:  
  ```json
  [
    {
      "operation": "shift",
      "spec": {
        "before": "[0]"
      }
    }
  ]
  ```  
- Transform Cache Size: `1`  
- Pretty Print: `false`  
- Max String Length: `20 MB`

**Saída**: JSON contendo apenas os dados do campo `before`.

**Conexão**: item 8 (success)

---

## 8. UpdateRecord  
**Descrição**: Adiciona campos de metadados ao JSON.

**Properties**:  
- Record Reader: `JsonTreeReader`  
- Record Writer: `JsonRecordSetWriter`  
- Replacement Value Strategy: `Literal Value`  
- `/__brz_ts_iso`: `${now():format("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'","UTC")}`  
- `/__brz_ts_ms`: `${now():toNumber()}`  
- `/__content`: `${content}`  
- `/__latency_ms`: `${now():toNumber():minus(${source_timestamp})}`  
- `/__op`: `${operation_type}`  
- `/__src_ts_iso`: `${source_timestamp:toNumber():toDate("UTC"):format("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "UTC")}`  
- `/__src_ts_ms`: `${source_timestamp}`

**Saída**: JSON completo com metadados incluindo timestamps de origem (PostgreSQL), de ingestão na camada bronze (Iceberg), latência entre eles, tipo de operação e conteúdo da mensagem.

**Conexão**: item 9 (success)

---

## 9. MergeRecord  
**Descrição**: Agrupa múltiplos registros em blocos para aumentar a eficiência do pipeline.

**Properties**:  
- Record Reader: `JsonTreeReader`  
- Record Writer: `JsonRecordSetWriter_MergeRecord`  
- Merge Strategy: `Bin-Packing Algorithm`  
- Attribute Strategy: `Keep Only Common Attributes`  
- Minimum Number of Records: `1`  
- Maximum Number of Records: `10000`  
- Minimum Bin Size: `0 B`  
- Maximum Bin Size: `20 MB`  
- Max Bin Age: `2 sec`  
- Maximum Number of Bins: `10`

**Conexão**: item 10

---

## 10. PutIceberg  
**Descrição**: Insere os registros na camada bronze do Iceberg.  
**Pré-requisito**: As tabelas bronze devem estar previamente criadas com o esquema compatível.

**Properties**:  
- Record Reader: `JsonTreeReaderAfter`  
- Catalog Service: `HiveCatalogService`  
- Catalog Namespace: `sefaz_brz`  
- Table Name: `brz_${kafka.topic:substringAfterLast('.')}`  
- Unmatched Column Behavior: `Ignore Unmatched Columns`  
- File Format: `PARQUET`  
- Maximum File Size: `No value set`  
- Kerberos User Service: `No value set`  
- Number of Commit Retries: `10`  
- Minimum Commit Wait Time: `100 ms`  
- Maximum Commit Wait Time: `2 sec`  
- Maximum Commit Duration: `30 sec`