"""
job_geo_pull_lotes_arcgis.py
Python 3.9+
Descrição: Script para extrair dados de lotes de um serviço ArcGIS Online
Entrada: -
Saída: arquivo GEOJSON 

Comando:
    python job_geo_pull_lotes_arcgis.py

Dependências:
    pip install arcgis geopandas pandas
"""

from arcgis.features import FeatureLayer
import geopandas as gpd
import pandas as pd

layer_url = "https://sig.niteroi.rj.gov.br/server/rest/services/Hosted/NGP_SMF_SEREC_A_LOTES_visualização/FeatureServer/30"
flayer = FeatureLayer(layer_url)

# Retorna todos os registros (faz paginação automática interna)
features = flayer.query(where="1=1", out_fields="*", return_geometry=True)

# Converter para Spatially Enabled DataFrame (Esri)
df = features.sdf  

# Exportar atributos para CSV (sem geometria)
df.drop(columns="SHAPE").to_csv("lotes.csv", index=False)

# Converter para GeoDataFrame do GeoPandas
# O campo de geometria no SEDF da Esri geralmente se chama 'SHAPE'
gdf = gpd.GeoDataFrame(df, geometry='SHAPE', crs=df.spatial.sr['wkid'] if 'wkid' in df.spatial.sr else 4326)

# Exportar para GeoJSON
gdf.to_file("lotes.geojson", driver="GeoJSON")

# Exportar para Shapefile
# gdf.to_file("lotes.shp")

gdf = gpd.read_file("lotes.geojson")
print(f"Total de registros: {len(gdf)}")

