"""
job_geo_transform_lotes.py
Python 3.9+
Descrição: Script para transformar dados de lotes em um formato específico JSON
Entrada: arquivo GEOJSON
Saída: arquivo JSONL (um objeto JSON por linha) pronto para ingestão no Iceberg via Spark/Trino

Comando:
    python job_geo_transform_lotes.py lotes.geojson lotes_transformados.geojson

Dependências:
    pip install shapely geopandas
"""

from typing import Dict, Any, List
import json
from pathlib import Path
from datetime import datetime, timezone
import logging

from shapely.geometry import shape
import geopandas as gpd  # usado apenas para conversão WKT (opcional)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# -----------------------
# Funções auxiliares
# -----------------------

def load_geojson(path: str) -> Dict[str, Any]:
    """Carrega um GeoJSON de disco."""
    p = Path(path)
    if not p.exists():
        raise FileNotFoundError(f"Arquivo não encontrado: {path}")
    with p.open("r", encoding="utf-8") as f:
        return json.load(f)


def geometry_to_wkt(geom: Dict[str, Any]) -> str:
    """Converte geometria GeoJSON para WKT (Well-Known Text)."""
    if not geom or "coordinates" not in geom:
        return None
    try:
        shapely_geom = shape(geom)
        return shapely_geom.wkt
    except Exception as e:
        logger.warning(f"Erro ao converter geometria para WKT: {e}")
        return None


def safe_str(value) -> str:
    """Converte qualquer valor para string, tratando None como ''."""
    if value is None:
        return ""
    return str(value).strip()


def safe_float(value) -> float:
    """Tenta converter para float, retorna 0.0 se falhar."""
    try:
        if value is None:
            return 0.0
        return float(value)
    except (ValueError, TypeError):
        return 0.0


def safe_timestamp(value) -> str:
    """Normaliza timestamp para ISO 8601 UTC."""
    if not value:
        return datetime.now(timezone.utc).isoformat()
    try:
        # Se for string, tenta parsear
        if isinstance(value, str):
            dt = datetime.fromisoformat(value.replace("Z", "+00:00"))
            return dt.isoformat()
        # Se for datetime, só formata
        elif isinstance(value, datetime):
            return value.isoformat()
        else:
            return datetime.now(timezone.utc).isoformat()
    except Exception:
        return datetime.now(timezone.utc).isoformat()


# -----------------------
# Função principal
# -----------------------

def build_output_record(feat: Dict[str, Any], source_file: str) -> Dict[str, Any]:
    """Converte uma feature GeoJSON em registro tabular para Iceberg."""
    props = feat.get("properties", {}) or {}
    geom = feat.get("geometry") or {}

    # Extrai geometria como WKT
    shape_wkt = geometry_to_wkt(geom)

    # Normaliza todos os campos — garante tipos consistentes
    record = {
        # Atributos originais
        "objectid": safe_str(props.get("objectid")),
        "tx_insct": safe_str(props.get("tx_insct")),
        "tx_logrado": safe_str(props.get("tx_logrado")),
        "tx_bairro": safe_str(props.get("tx_bairro")),
        "tx_loteame": safe_str(props.get("tx_loteame")),
        "tx_observ": safe_str(props.get("tx_observ")),
        "globalid_1": safe_str(props.get("globalid_1")),
        "db_lng": safe_float(props.get("db_lng")),          # longitude
        "db_lat": safe_float(props.get("db_lat")),          # latitude
        "created_date": safe_timestamp(props.get("created_date")),
        "last_edited_date": safe_timestamp(props.get("last_edited_date")),
        "created_user": safe_str(props.get("created_user")),
        "last_edited_user": safe_str(props.get("last_edited_user")),
        "tx_zoneamento": safe_str(props.get("tx_zoneamento")),
        "tx_hier_via": safe_str(props.get("tx_hier_via")),
        "tx_streetview": safe_str(props.get("tx_streetview")),
        "tx_nroproc": safe_str(props.get("tx_nroproc")),
        "SHAPE__Area": safe_float(props.get("SHAPE__Area")),
        "SHAPE__Length": safe_float(props.get("SHAPE__Length")),

        # Geometria
        "shape_wkt": shape_wkt or "",

        # Metadados de ingestão
        "source_file": source_file,
        "ingestion_timestamp": datetime.now(timezone.utc).isoformat(),
    }

    # Adiciona campos extras não mapeados
    for key, value in props.items():
        if key not in record:
            record[f"extra_{key}"] = safe_str(value)

    return record


def process_file(input_path: str, output_path: str) -> None:
    logger.info("Carregando GeoJSON de: %s", input_path)
    data = load_geojson(input_path)
    features = data.get("features", [])
    logger.info("Total de features lidas: %d", len(features))

    # Filtra features válidas (com geometria e propriedades)
    features = [
        feat for feat in features
        if feat.get("properties") is not None and feat.get("geometry") is not None
    ]
    logger.info("Features após filtro (com propriedades e geometria): %d", len(features))

    out_path = Path(output_path)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    source_file_name = Path(input_path).name

    with out_path.open("w", encoding="utf-8") as f:
        for i, feat in enumerate(features):
            try:
                rec = build_output_record(feat, source_file_name)
                f.write(json.dumps(rec, ensure_ascii=False, separators=(',', ':')) + '\n')
                if (i + 1) % 1000 == 0:
                    logger.info("Processados %d registros...", i + 1)
            except Exception as e:
                logger.exception("Erro processando feature #%d: %s", i, e)

    logger.info("✅ Arquivo salvo em: %s (registros válidos: %d)", output_path, len(features))


# -----------------------
# Execução CLI
# -----------------------

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Converte GeoJSON para JSONL compatível com Iceberg")
    parser.add_argument("input", help="Caminho para o GeoJSON de entrada")
    parser.add_argument("output", help="Caminho para o JSON de saída (formato JSONL)")
    args = parser.parse_args()

    process_file(args.input, args.output)