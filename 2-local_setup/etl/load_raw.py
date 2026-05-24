"""
Carrega CSVs de 1-data para o Postgres (schema staging, tabelas stg_*).
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine

RAW_SCHEMA = "raw"
CHUNK_SIZE = 5_000

SETUP_DIR = Path(__file__).resolve().parents[1]
PROJECT_ROOT = SETUP_DIR.parent
DATA_DIR = PROJECT_ROOT / "1-data"
ENV_FILE = SETUP_DIR / ".env"


def csv_to_table_name(csv_path: Path) -> str:
    """tb_customers.csv -> stg_customers; olist_products_dataset.csv -> stg_olist_products_dataset."""
    stem = csv_path.stem
    if stem.startswith("tb_"):
        stem = stem[3:]
    return f"raw_{stem}"


def build_engine() -> Engine:
    load_dotenv(ENV_FILE)

    user = os.environ.get("DBT_USER", "postgres")
    password = os.environ.get("DBT_PASSWORD", "postgres")
    host = os.environ.get("DBT_HOST", "localhost")
    port = os.environ.get("DBT_PORT", "5433")
    database = os.environ.get("DBT_DATABASE", "dbt_db")

    url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
    return create_engine(url, pool_pre_ping=True)


def ensure_raw_schema(engine: Engine) -> None:
    with engine.begin() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {RAW_SCHEMA}"))


def load_csv(engine: Engine, csv_path: Path) -> tuple[str, int]:
    table_name = csv_to_table_name(csv_path)
    df = pd.read_csv(csv_path, low_memory=False)
    df.columns = [c.strip().lower() for c in df.columns]

    row_count = len(df)
    df.to_sql(
        table_name,
        engine,
        schema=RAW_SCHEMA,
        if_exists="replace",
        index=False,
        method="multi",
        chunksize=CHUNK_SIZE,
    )
    return table_name, row_count


def run(data_dir: Path | None = None) -> None:
    source = data_dir or DATA_DIR
    if not source.is_dir():
        raise FileNotFoundError(f"Pasta de dados não encontrada: {source}")

    csv_files = sorted(source.glob("*.csv"))
    if not csv_files:
        raise FileNotFoundError(f"Nenhum CSV em {source}")

    engine = build_engine()
    ensure_raw_schema(engine)

    print(f"Destino: schema `{RAW_SCHEMA}` @ {engine.url.render_as_string(hide_password=True)}")
    print(f"Origem:  {source}\n")

    for csv_path in csv_files:
        table_name, rows = load_csv(engine, csv_path)
        print(f"  {csv_path.name} -> {RAW_SCHEMA}.{table_name} ({rows:,} linhas)")

    print("\nETL concluído.")


def main() -> None:
    try:
        run()
    except Exception as exc:
        print(f"Erro: {exc}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
