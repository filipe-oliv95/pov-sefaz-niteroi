documentation: https://trino.io/docs/current/develop/client-protocol.html


curl -X POST \
  http://192.168.122.220:8060/v1/statement \
  -H "X-Trino-User: trino" \
  -H "Content-Type: application/json" \
  -d '{"query": "SELECT * FROM iceberg.sefaz_niteroi_bronze.lote LIMIT 10"}'