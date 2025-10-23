#!/bin/bash
hdfs dfs -mkdir -p /warehouse/tablespace/iceberg/sefaz/raw
hdfs dfs -mkdir -p /warehouse/tablespace/iceberg/sefaz/bronze
hdfs dfs -mkdir -p /warehouse/tablespace/iceberg/sefaz/silver
hdfs dfs -mkdir -p /warehouse/tablespace/iceberg/sefaz/gold

hdfs dfs -chmod -R 777 /warehouse/tablespace/iceberg/sefaz/raw
hdfs dfs -chmod -R 777 /warehouse/tablespace/iceberg/sefaz/bronze
hdfs dfs -chmod -R 777 /warehouse/tablespace/iceberg/sefaz/silver
hdfs dfs -chmod -R 777 /warehouse/tablespace/iceberg/sefaz/gold