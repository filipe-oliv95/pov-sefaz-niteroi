verificar status do kafka connect:
curl http://localhost:8087

Listar os conectores:
curl -s http://localhost:8087/connectors | jq -r '.[]'

apagar um conector:
curl -X DELETE http://localhost:8087/connectors/kcnn_ecidades_cadastro_v1

logs:
tail -f /var/log/kafka-connect.log
tail -n 100 /var/log/kafka-connect.log
grep "snapshot" /var/log/kafka-connect.log