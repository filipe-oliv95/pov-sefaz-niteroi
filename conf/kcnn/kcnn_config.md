## Kafka Connect

1. **Editar o arquivo de configurações** `/etc/kafka/2.3/0/connect-distributed.properties`:

   ```bash
   bootstrap.servers=Worker-Node01.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:6667,Worker-Node02.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:6667
   rest.port=8087
   rest.host.name=0.0.0.0
   plugin.path=/usr/tdp/2.3/kafka/connect-plugins
   ```

2. **Rodar o Kafka Connect:**

   ```bash
   nohup env JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.16.0.8-2.el9.x86_64 PATH=$JAVA_HOME/bin:$PATH /usr/tdp/2.3/kafka/bin/connect-distributed.sh /etc/kafka/2.3/0/connect-distributed.properties > /var/log/kafka-connect.log 2>&1 &
   ```

3. **Verificar logs do Kafka Connect:**

   ```bash
   # Logs em tempo real
   tail -f /var/log/kafka-connect.log

   # Últimas linhas dos logs
   tail -n 100 /var/log/kafka-connect.log
   ```

4. **Verificar se o Kafka Connect está ativo:**

   ```bash
   curl http://localhost:8087
   ```

5. **Verificar se os tópicos internos do Debezium foram criados no Kafka:**

   * `connect-configs`
   * `connect-offsets`
   * `connect-status`

6. **Comandos úteis do Kafka Connect:**

   | Comando                                                            | Descrição                        |
   | ------------------------------------------------------------------ | -------------------------------- |
   | `tail -f /var/log/kafka-connect.log`                               | Acompanha os logs em tempo real  |
   | `tail -n 100 /var/log/kafka-connect.log`                           | Exibe as últimas linhas dos logs |
   | `curl http://localhost:8087/connectors`                            | Lista todos os conectores ativos |
   | `curl -X DELETE http://localhost:8087/connectors/<connector_name>` | Remove um conector existente     |
