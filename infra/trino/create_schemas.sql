-- Bronze
CREATE SCHEMA IF NOT EXISTS iceberg.sefaz_brz
WITH (location = 'hdfs://master-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:8020/warehouse/tablespace/iceberg/sefaz/bronze');

-- Silver
CREATE SCHEMA IF NOT EXISTS iceberg.sefaz_slv
WITH (location = 'hdfs://master-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:8020/warehouse/tablespace/iceberg/sefaz/silver');

-- Gold
CREATE SCHEMA IF NOT EXISTS iceberg.sefaz_gld
WITH (location = 'hdfs://master-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:8020/warehouse/tablespace/iceberg/sefaz/gold');