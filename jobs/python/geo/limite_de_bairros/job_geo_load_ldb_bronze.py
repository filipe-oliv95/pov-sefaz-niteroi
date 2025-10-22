"""
job_geo_load_ldb_bronze.py
Python 3.9+
Descrição: Script pyspark para carregar dados de limites de bairros em formato JSONL para a tabela Bronze do Iceberg
Pré-requisito: 
    - tabela Iceberg já criada
    - limite_de_bairros.json inserido no HDFS com permissões adequadas
Saída: tabela Iceberg

Comando:
    spark-submit --packages org.apache.iceberg:iceberg-spark-runtime-3.3_2.12:1.4.2 job_geo_load_ldb_bronze.py
"""

from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from pyspark.sql import functions as F

# Cria a SparkSession com suporte ao Iceberg e Hive
spark = SparkSession.builder \
    .appName("Ingest Limite de Bairros JSON to Iceberg Bronze") \
    .master("local[*]") \
    .enableHiveSupport() \
    .config("spark.hadoop.fs.defaultFS", "hdfs://master-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:8020") \
    .config("spark.sql.catalog.iceberg", "org.apache.iceberg.spark.SparkCatalog") \
    .config("spark.sql.catalog.iceberg.type", "hive") \
    .config("spark.sql.catalog.iceberg.uri", "thrift://utility-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:9083") \
    .config("spark.sql.catalog.iceberg.warehouse", "hdfs:///warehouse/tablespace/iceberg") \
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions") \
    .config("spark.sql.iceberg.handle-timestamp-without-timezone", "true") \
    .getOrCreate()

# Caminho do arquivo JSONL
json_path = "hdfs:///warehouse/tablespace/iceberg/sefaz/raw/limite_de_bairros.json"

# Nome da tabela Iceberg (já existente)
tabela_nome = "iceberg.sefaz_brz.brz_limite_de_bairros"

# Lê o JSONL
df = spark.read.json(json_path)

# RENOMEIE as colunas antes de selecionar
df = df.withColumnRenamed("SHAPE__Length", "shape_length") \
       .withColumnRenamed("SHAPE__Area", "shape_area") \
       .withColumnRenamed("tx_nome", "tx_bairro") \
       .withColumnRenamed("shape_wkt", "border") 

# Mostra schema inferido (opcional, para debug)
df.printSchema()

# Renomeia ou seleciona apenas as colunas que existem na tabela Iceberg
# Garante que os tipos e nomes batem exatamente
df_selected = df.select(
    col("tx_bairro").cast("string"),
    col("shape_length").cast("double"),
    col("shape_area").cast("double"),
    col("tx_legislacao").cast("string"),
    col("border").cast("string")
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