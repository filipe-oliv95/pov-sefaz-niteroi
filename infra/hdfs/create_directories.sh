#!/bin/bash
HDFS_BASE="/warehouse/tablespace/iceberg/sefaz"

hdfs dfs -mkdir -p ${HDFS_BASE}/raw
hdfs dfs -mkdir -p ${HDFS_BASE}/bronze
hdfs dfs -mkdir -p ${HDFS_BASE}/silver
hdfs dfs -mkdir -p ${HDFS_BASE}/gold

hdfs dfs -chmod -R 777 ${HDFS_BASE}/raw
hdfs dfs -chmod -R 777 ${HDFS_BASE}/bronze
hdfs dfs -chmod -R 777 ${HDFS_BASE}/silver
hdfs dfs -chmod -R 777 ${HDFS_BASE}/gold