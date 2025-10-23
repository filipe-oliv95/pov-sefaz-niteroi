# Trino

## Conexão com Iceberg
No Ambari, acessar o painél do trino e ligar o conector com o Iceberg.

## Exportar variáveis Java
Para conseguir acessar o Trino CLI, é preciso exportar as variáveis de ambiente Java no terminal do servidor:

```
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.16.0.8-2.el9.x86_64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```