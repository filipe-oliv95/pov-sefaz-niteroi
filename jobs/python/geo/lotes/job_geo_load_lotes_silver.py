"""
Código spark que pega a tabela iceberg.sefaz_brz.brz_lotes_arcgis, integra com iceberg.sefaz_slv.slv_limite_de_bairros e gera a tabela enriquecida iceberg.sefaz_slv.slv_lotes_enriquecido
silver_lotes.py
Python 3.9+
Entrada: iceberg.sefaz_brz.brz_lotes_arcgis - tabela de lotes no iceberg bronze
Saída: iceberg.sefaz_slv.slv_lotes_enriquecido - insert dos dados limpos e com flags na camada silver do iceberg

Comando:
    python job_geo_load_lotes_silver.py

Dependências:
    pip install pyspark apache-sedona==1.5.1
"""

from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col, when, lit, isnan, lower, trim,
    count, broadcast, expr, regexp_replace
)
from pyspark.sql import functions as F

# Inicializa Spark com Sedona
def init_spark():
    spark = (
        SparkSession.builder
        .appName("Enriquecimento Silver Lotes")
        .master("local[*]")
        .enableHiveSupport()
        .config("spark.hadoop.fs.defaultFS", "hdfs://master-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:8020")
        .config("spark.hadoop.dfs.replication", "1")
        .config("spark.sql.catalog.iceberg", "org.apache.iceberg.spark.SparkCatalog")
        .config("spark.sql.catalog.iceberg.type", "hive")
        .config("spark.sql.catalog.iceberg.uri", "thrift://utility-node.bv00rqbdsnuujdgy3kanxosw4e.nx.internal.cloudapp.net:9083")
        .config("spark.sql.catalog.iceberg.warehouse", "hdfs:///warehouse/tablespace/iceberg")
        .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
        .config("spark.sql.iceberg.handle-timestamp-without-timezone", "true")
        .getOrCreate()
    )

    # Registra funções do Sedona
    from sedona.register import SedonaRegistrator
    SedonaRegistrator.registerAll(spark)
    return spark


def utm_to_wgs84_spark(df):
    # Separar registros válidos (para conversão) e inválidos
    df_valid = df.filter(
        (col("flag_db_lat_lng_invalido") == 0)
    )
    
    df_invalid = df.filter(
        (col("flag_db_lat_lng_invalido") == 1)
    ).withColumn("db_lat_geo", lit(None).cast("double")) \
     .withColumn("db_lng_geo", lit(None).cast("double"))

    # Converter coordenadas UTM (EPSG:32723) → WGS84 (EPSG:4326) usando Sedona
    df_valid_geo = df_valid \
        .withColumn("geom_utm", expr("ST_Point(db_lng, db_lat)")) \
        .withColumn("geom_utm", expr("ST_SetSRID(geom_utm, 32723)")) \
        .withColumn("geom_wgs84", expr("ST_Transform(geom_utm, 'EPSG:32723', 'EPSG:4326')")) \
        .withColumn("db_lng_geo", expr("ST_X(geom_wgs84)")) \
        .withColumn("db_lat_geo", expr("ST_Y(geom_wgs84)")) \
        .drop("geom_utm", "geom_wgs84")

    # Combinar os dois subconjuntos
    return df_valid_geo.unionByName(df_invalid)


# Função auxiliar para normalizar texto (remover acentos aproximadamente)
def normalize_text(col_name):
    # Aplica sequência de substituições para remover acentos
    cleaned = lower(trim(col(col_name)))
    replacements = [
        ("á|à|ã|â|ä", "a"),
        ("é|è|ê|ë", "e"),
        ("í|ì|î|ï", "i"),
        ("ó|ò|õ|ô|ö", "o"),
        ("ú|ù|û|ü", "u"),
        ("ç", "c"),
        ("Á|À|Ã|Â|Ä", "A"),
        ("É|È|Ê|Ë", "E"),
        ("Í|Ì|Î|Ï", "I"),
        ("Ó|Ò|Õ|Ô|Ö", "O"),
        ("Ú|Ù|Û|Ü", "U"),
        ("Ç", "C")
    ]
    for pattern, replacement in replacements:
        cleaned = regexp_replace(cleaned, pattern, replacement)
    return cleaned


# Função principal
def process_lotes_bronze_to_silver(spark):
    # 1. Ler lotes bronze
    df_lotes = spark.table("iceberg.sefaz_brz.brz_lotes_arcgis")

    # 2. Criar flags de qualidade — todas com valor padrão 0 (false)
    df_flags = (
        df_lotes
        .withColumn(
            "flag_tx_bairro_invalido",
            when(
                (col("tx_bairro").isNull()) |
                (trim(col("tx_bairro")) == "") |
                (col("tx_bairro") == "0"),
                lit(1)
            ).otherwise(lit(0))
        )
        .withColumn(
            "flag_tx_insct_invalido",
            when(
                (col("tx_insct").isNull()) |
                (trim(col("tx_insct")) == "") |
                (col("tx_insct") == "0"),
                lit(1)
            ).otherwise(lit(0))
        )
        .withColumn(
            "flag_db_lat_lng_invalido",
            when(
                col("db_lat").isNull() |
                col("db_lng").isNull() |
                (col("db_lat") == lit(0)) |
                (col("db_lng") == lit(0)) |
                isnan(col("db_lat")) |
                isnan(col("db_lng")),
                lit(1)
            ).otherwise(lit(0))
        )
    )

    # 3. Marcar duplicados de tx_insct (válido apenas se não for inválido)
    df_with_dup_flag = (
        df_flags
        .withColumn("tx_insct_clean", when(col("flag_tx_insct_invalido") == 1, None).otherwise(col("tx_insct")))
    )

    # Contagem de ocorrências
    insct_counts = df_with_dup_flag.groupBy("tx_insct_clean").agg(count("*").alias("cnt"))
    df_dup = (
        df_with_dup_flag
        .join(insct_counts, on="tx_insct_clean", how="left")
        .withColumn(
            "flag_tx_insct_duplicado",
            when(
                (col("cnt") > 1) & (col("flag_tx_insct_invalido") == 0),
                lit(1)
            ).otherwise(lit(0))
        )
        .drop("tx_insct_clean", "cnt")
    )

    # 4. Converter coordenadas UTM → WGS84 (apenas se tx_insct válido E coordenadas válidas)
    df_with_geo = utm_to_wgs84_spark(df_dup)

    # 5. Criar geometria ponto com Sedona (apenas onde temos coordenadas geográficas)
    df_points = df_with_geo.filter(
        col("db_lat_geo").isNotNull() & col("db_lng_geo").isNotNull()
    )
    df_points = df_points.withColumn(
        "geom_point",
        expr("ST_Point(db_lng_geo, db_lat_geo)")
    )

    # 6. Ler limites de bairros (52 registros)
    df_bairros = spark.table("iceberg.sefaz_slv.limite_de_bairros")
    df_bairros = df_bairros.withColumn(
        "geom_border",
        expr("ST_GeomFromWKT(border)")
    )

    # Broadcast dos bairros (pequeno: 52 linhas) para eficiência
    df_bairros_bc = broadcast(df_bairros)

    # 7. Spatial join: ponto dentro do polígono (usa Sedona)
    df_joined = (
        df_points.alias("p")
        .join(
            df_bairros_bc.alias("b"),
            expr("ST_Contains(b.geom_border, p.geom_point)"),
            how="left"
        )
        .select(
            col("p.*"),
            col("b.tx_bairro").alias("bairro_geo")
        )
    )

    # 8. Combinar com registros que não têm coordenadas ou não foram convertidos
    df_no_geo = df_with_geo.filter(
        col("db_lat_geo").isNull() | col("db_lng_geo").isNull()
    )
    df_final_with_geo = df_joined.unionByName(
        df_no_geo.withColumn("bairro_geo", lit(None)),
        allowMissingColumns=True
    )

    # 9. Nova flag: inconsistência entre tx_bairro e bairro_geo
    df_final_normalized = df_final_with_geo \
        .withColumn("tx_bairro_norm", normalize_text("tx_bairro")) \
        .withColumn("bairro_geo_norm", normalize_text("bairro_geo"))

    df_final = df_final_normalized.withColumn(
        "flag_tx_bairro_geo_inconsistente",
        when(
            col("tx_bairro_norm").isNotNull() &
            col("bairro_geo_norm").isNotNull() &
            (col("tx_bairro_norm") != col("bairro_geo_norm")),
            lit(1)
        ).otherwise(lit(0))
    ).drop("tx_bairro_norm", "bairro_geo_norm", "geom_point")

    print("DF FINAL SCHEMA")
    df_final.printSchema()
    
    sc = spark.sparkContext
    hadoop_conf = sc._jsc.hadoopConfiguration()
    hadoop_conf.set("dfs.replication", "1")

    # Nome da tabela Iceberg (já existente)
    tabela_nome = "iceberg.sefaz_slv.slv_lotes_enriquecido"

    # Insere na tabela Iceberg (modo overwrite — apaga e reescreve)
    # Use .mode("append") se quiser adicionar sem apagar
    df_final.writeTo(tabela_nome).overwrite(F.lit(True))

# Execução
if __name__ == "__main__":
    spark = init_spark()
    process_lotes_bronze_to_silver(spark)
    spark.stop()