### Verificar status do kafka connect:
```bash
curl http://localhost:8087
```
### Listar os conectores:
```bash
curl -s http://localhost:8087/connectors | jq -r '.[]'
```
### Apagar um conector:
```bash
curl -X DELETE http://localhost:8087/connectors/kcnn_ecidades_cadastro_v1
```
### Verificar logs:
```bash
tail -f /var/log/kafka-connect.log
tail -n 100 /var/log/kafka-connect.log
grep "snapshot" /var/log/kafka-connect.log
```