-- 1. Verificar publicações existentes
-- Listar todas as publicações
SELECT pubname, pubowner::regrole, puballtables, pubinsert, pubupdate, pubdelete, pubtruncate
FROM pg_publication;

-- 2. Dropar uma publication
DROP PUBLICATION IF EXISTS pub_ecidades_cadastro_v9;

-- 3. Verificar slots de replicação
-- Listar todos os slots de replicação
SELECT slot_name, plugin, slot_type, database, active, restart_lsn, confirmed_flush_lsn
FROM pg_replication_slots;

-- apaga o slot de replicação
SELECT pg_drop_replication_slot('slot_ecidades_cadastro_v9');

-- mostra o maximo de slots e wal senders
SHOW max_replication_slots;
SHOW max_wal_senders;  

SHOW max_connections;

SELECT * FROM pg_publication_tables;

drop publication pub_ecidades_cadastro_v7;