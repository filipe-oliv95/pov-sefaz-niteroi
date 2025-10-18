"""
job_geo_load_lotes_bronze.py
Python 3.9+
Descrição: Script pyspark para carregar dados de lotes em formato JSONL para a tabela Bronze do Iceberg
Pré-requisito: 
    - tabela Iceberg já criada
    - lotes.json inserido no HDFS com permissões adequadas
Saída: tabela Iceberg

Comando:
    python job_geo_load_lotes_bronze.py

Dependências:
    pip install pyspark
"""

from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from pyspark.sql import functions as F

# Cria a SparkSession com suporte ao Iceberg e Hive
spark = SparkSession.builder \
    .appName("Ingest Lotes JSON to Iceberg Bronze") \
    .master("local[*]") \
    .enableHiveSupport() \
    .config("spark.hadoop.fs.defaultFS", "hdfs://sandbox-tdp23.tecnisys.com.br:8020") \
    .config("spark.sql.catalog.iceberg", "org.apache.iceberg.spark.SparkCatalog") \
    .config("spark.sql.catalog.iceberg.type", "hive") \
    .config("spark.sql.catalog.iceberg.uri", "thrift://sandbox-tdp23.tecnisys.com.br:9083") \
    .config("spark.sql.catalog.iceberg.warehouse", "hdfs:///warehouse/tablespace/iceberg") \
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions") \
    .config("spark.sql.iceberg.handle-timestamp-without-timezone", "true") \
    .getOrCreate()

# Caminho do arquivo JSONL
json_path = "hdfs:///warehouse/tablespace/iceberg/sefaz/raw/lotes.json"

# Nome da tabela Iceberg (já existente)
tabela_nome = "iceberg.sefaz_brz.brz_lotes_arcgis"

# Lê o JSONL
df = spark.read.json(json_path)

# RENOMEIE as colunas antes de selecionar
df = df.withColumnRenamed("SHAPE__Length", "shape_Length") \
       .withColumnRenamed("SHAPE__Area", "shape_Area")

# Mostra schema inferido (opcional, para debug)
df.printSchema()

# Renomeia ou seleciona apenas as colunas que existem na tabela Iceberg
# Garante que os tipos e nomes batem exatamente
df_selected = df.select(
    col("tx_insct").cast("string"),
    col("tx_nroproc").cast("string"),
    col("tx_logrado").cast("string"),
    col("tx_loteame").cast("string"),
    col("tx_observ").cast("string"),
    col("globalid_1").cast("string"),
    col("tx_bairro").cast("string"),
    col("tx_streetview").cast("string"),
    col("db_lng").cast("double"),
    col("db_lat").cast("double"),
    col("created_date").cast("timestamp"),
    col("created_user").cast("string"),
    col("last_edited_date").cast("timestamp"),
    col("last_edited_user").cast("string"),
    col("tx_zoneamento").cast("string"),
    col("tx_hier_via").cast("string"),
    col("shape_Length").cast("double"),
    col("shape_Area").cast("double")
)

# Opcional: mostra contagem e primeiras linhas
print(f"✅ Total de registros lidos: {df_selected.count()}")
df_selected.show(3, truncate=False)

# Insere na tabela Iceberg (modo overwrite — apaga e reescreve)
# Use .mode("append") se quiser adicionar sem apagar
df_selected.writeTo(tabela_nome).overwrite(F.lit(True))

# ✅ Ou, se preferir usar o formato antigo (ainda válido):
# df_selected.write.format("iceberg").mode("overwrite").saveAsTable(tabela_nome)

print(f"✅ Dados inseridos com sucesso na tabela: {tabela_nome}")

spark.stop()