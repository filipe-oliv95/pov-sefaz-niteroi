
Listar tópicos kafka:
JAVA_HOME=/usr/lib/jvm/jdk8u402-b06 PATH=/usr/lib/jvm/jdk8u402-b06/bin:$PATH \
/usr/tdp/2.3/kafka/bin/kafka-topics.sh \
  --bootstrap-server worker-node01.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:6667 \
  --list

Listar numero de mensagens do tópico:
env JAVA_HOME=/usr/lib/jvm/jdk8u402-b06 PATH=/usr/lib/jvm/jdk8u402-b06/bin:$PATH /usr/tdp/2.3/kafka/bin/kafka-run-class.sh kafka.tools.GetOffsetShell \
  --broker-list Worker-Node01.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:6667 \
  --topic ecidades.cadastro.iptubase

apagar tópico kafka:
JAVA_HOME=/usr/lib/jvm/jdk8u402-b06 PATH=/usr/lib/jvm/jdk8u402-b06/bin:$PATH \
/usr/tdp/2.3/kafka/bin/kafka-topics.sh \
  --bootstrap-server worker-node01.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:6667 \
  --delete --topic ecidades.cadastro.loteloc
