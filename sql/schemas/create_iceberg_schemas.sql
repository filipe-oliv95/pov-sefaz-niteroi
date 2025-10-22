CREATE SCHEMA iceberg.sefaz_sefaz_brz
WITH (location = 'hdfs://master-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:8020/warehouse/tablespace/iceberg/sefaz/bronze');

CREATE SCHEMA iceberg.sefaz_slv
WITH (location = 'hdfs://master-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:8020/warehouse/tablespace/iceberg/sefaz/silver');

CREATE SCHEMA iceberg.sefaz_gld
WITH (location = 'hdfs://master-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:8020/warehouse/tablespace/iceberg/sefaz/gold');