"""
DAG olist_pipeline — orquestra apenas transformações dbt.

Fluxo:
  Postgres raw.* (já populado pelo ETL em 2-local_setup)
    → Cosmos DbtTaskGroup
    → dbt run/test por modelo (staging → int → marts)

Conexões:
  - profile_config.conn_id="olist_postgres"  ← airflow_settings.yaml
  - DBT_PROJECT_PATH                          ← docker-compose.override.yml monta dbt_olist/
  - dbt_executable_path                       ← Dockerfile cria dbt_venv
"""

import os

from airflow import DAG
from cosmos import DbtTaskGroup, ExecutionConfig, ProfileConfig, ProjectConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping
from pendulum import datetime

# Caminho do projeto dbt dentro do container Astro (volume: ./dbt_olist)
DBT_PROJECT_PATH = "/usr/local/airflow/dbt_olist"

# Cosmos monta o profile dbt a partir da Airflow Connection (não usa ~/.dbt/profiles.yml)
profile_config = ProfileConfig(
    profile_name="dbt_olist",  # deve bater com dbt_project.yml → profile: 'dbt_olist'
    target_name="dev",
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="olist_postgres",  # definida em airflow_settings.yaml → host.docker.internal:5433
        profile_args={"schema": "public"},  # schema onde dbt materializa staging/int/marts
    ),
)

# dbt roda em venv separado (instalado no Dockerfile), não no Python do Airflow
execution_config = ExecutionConfig(
    dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt",
)

project_config = ProjectConfig(
    dbt_project_path=DBT_PROJECT_PATH,
)

with DAG(
    dag_id="olist_pipeline",
    schedule="@daily",
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["olist", "dbt"],
    default_args={"retries": 2},
) as dag:
    # Cosmos lê o manifest/dbt ls e cria 1 task Airflow por modelo + teste,
    # respeitando dependências ref() definidas em 3-dbt/dbt_olist/models/
    dbt_transform = DbtTaskGroup(
        group_id="dbt_transform",
        project_config=project_config,
        profile_config=profile_config,
        execution_config=execution_config,
        operator_args={"install_deps": True},
    )
