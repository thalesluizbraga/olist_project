"""
Carrega CSVs de /usr/local/airflow/data para o Postgres (schema raw).
Usado pela DAG do Airflow; credenciais via variáveis de ambiente ou .env local.
"""

from __future__ import annotations

import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, inspect, text
from sqlalchemy.engine import Engine

RAW_SCHEMA = "raw"
CHUNK_SIZE = 5_000

AIRFLOW_HOME = Path(os.environ.get("AIRFLOW_HOME", "/usr/local/airflow"))
DATA_DIR = AIRFLOW_HOME / "data"
ENV_FILE = AIRFLOW_HOME / ".env"


def csv_to_table_name(csv_path: Path) -> str:
    stem = csv_path.stem
    if stem.startswith("tb_"):
        stem = stem[3:]
    return f"raw_{stem}"


def build_engine() -> Engine:
    if ENV_FILE.is_file():
        load_dotenv(ENV_FILE)

    user = os.environ.get("DBT_USER", "postgres")
    password = os.environ.get("DBT_PASSWORD", "postgres")
    host = os.environ.get("DBT_HOST", "host.docker.internal")
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
    inspector = inspect(engine)
    table_exists = table_name in inspector.get_table_names(schema=RAW_SCHEMA)

    if table_exists:
        with engine.begin() as conn:
            conn.execute(text(f"TRUNCATE TABLE {RAW_SCHEMA}.{table_name}"))

    df.to_sql(
        table_name,
        engine,
        schema=RAW_SCHEMA,
        if_exists="append" if table_exists else "replace",
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
