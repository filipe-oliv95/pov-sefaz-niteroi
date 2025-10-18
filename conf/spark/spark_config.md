# Spark

## Adição de JARs

Adicione os seguintes JARs ao Spark no diretório `/usr/tdp/2.3/spark3/jars/`:

- [geotools-wrapper 1.5.1-28.2](https://mvnrepository.com/artifact/org.datasyslab/geotools-wrapper/1.5.1-28.2)
- [sedona-spark-shaded 1.5.1](https://mvnrepository.com/artifact/org.apache.sedona/sedona-spark-shaded-3.0_2.12/1.5.1)

## Instalação de bibliotecas no ambiente virtual

No virtual environment do Python, instale as seguintes bibliotecas:

```bash
pip install pandas numpy pyproj apache-sedona==1.5.1 geopandas shapely
