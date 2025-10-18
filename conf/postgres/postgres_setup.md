# PostgreSQL Setup

Este documento descreve as configurações necessárias no PostgreSQL para habilitar o uso do conector **Debezium** com **Kafka**, permitindo a captura de alterações (CDC) de tabelas específicas do banco **poc_ecidade_markway**.

---

## Usuário de Replicação

1. Criar um usuário dedicado ao Debezium com permissões de replicação:

```sql
CREATE USER speedlayer WITH PASSWORD 'speedlayer123';
ALTER ROLE speedlayer WITH REPLICATION LOGIN SUPERUSER;
GRANT ALL PRIVILEGES ON DATABASE poc_ecidade_markway TO speedlayer;
```

O usuário deve ter permissão de update e criação de *publication* no PostgreSQL, o que envolve ser **SUPERUSER** e **owner** das tabelas.

---

## Configuração de WAL

1. Alterar as seguintes propriedades no arquivo de configuração do PostgreSQL (`/var/lib/pgsql/14/data/postgresql.conf`):

```bash
wal_level = logical
max_replication_slots = 10
max_wal_senders = 10
```

2. Reiniciar o serviço PostgreSQL:

```bash
sudo systemctl restart postgresql-14.service
```

---

## Configurações de Acesso

1. Incluir as seguintes linhas no arquivo `/var/lib/pgsql/14/data/pg_hba.conf`:

```bash
host    replication     speedlayer     <ip-servidor>/32    md5
host    all             speedlayer     <ip-servidor>/32    md5
```

2. Reiniciar o PostgreSQL para aplicar as alterações:

```bash
sudo systemctl restart postgresql-14.service
```

---

## Configurações de Database, Schema e Tabelas

1. Conceder as seguintes permissões ao usuário `speedlayer`:

```sql
GRANT CONNECT ON DATABASE poc_ecidade_markway TO speedlayer;
GRANT USAGE ON SCHEMA cadastro TO speedlayer;
GRANT SELECT ON ALL TABLES IN SCHEMA cadastro TO speedlayer;
ALTER DEFAULT PRIVILEGES IN SCHEMA cadastro GRANT SELECT ON TABLES TO speedlayer;
```

---

## Observações

* O `wal_level` deve estar configurado como **logical**, caso contrário o Debezium não conseguirá ler as alterações.
* Cada conector Debezium usa um *replication slot*, então ajuste `max_replication_slots` conforme o número de conectores ativos.
* Após qualquer alteração de configuração nos arquivos `postgresql.conf` ou `pg_hba.conf`, o PostgreSQL deve ser reiniciado.
* É recomendável validar se o usuário configurado consegue criar *publications* e *replication slots* antes de registrar o conector Debezium.
