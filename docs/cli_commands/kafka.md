
### Listar tópicos kafka:
```bash
JAVA_HOME=/usr/lib/jvm/jdk8u402-b06 PATH=/usr/lib/jvm/jdk8u402-b06/bin:$PATH \
/usr/tdp/2.3/kafka/bin/kafka-topics.sh \
  --bootstrap-server worker-node01.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:6667 \
  --list
```

### Listar numero de mensagens do tópico:
```bash
env JAVA_HOME=/usr/lib/jvm/jdk8u402-b06 PATH=/usr/lib/jvm/jdk8u402-b06/bin:$PATH /usr/tdp/2.3/kafka/bin/kafka-run-class.sh kafka.tools.GetOffsetShell \
  --broker-list Worker-Node01.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:6667 \
  --topic ecidades.cadastro.iptubase
```

### Apagar tópico kafka:
```bash
JAVA_HOME=/usr/lib/jvm/jdk8u402-b06 PATH=/usr/lib/jvm/jdk8u402-b06/bin:$PATH \
/usr/tdp/2.3/kafka/bin/kafka-topics.sh \
  --bootstrap-server worker-node01.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:6667 \
  --delete --topic ecidades.cadastro.loteloc
```