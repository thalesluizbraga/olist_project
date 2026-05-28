# Imagem base: Astro Runtime 3.2 (Airflow 3.2) — ver docs/SETUP.md
FROM astrocrpublic.azurecr.io/runtime:3.2-4

# Airflow e dbt usam ambientes Python separados.
# O Cosmos executa este binário (ver dags/dag.py → execution_config.dbt_executable_path)
RUN python -m venv /usr/local/airflow/dbt_venv && \
    /usr/local/airflow/dbt_venv/bin/pip install --no-cache-dir \
        "dbt-core>=1.11.0,<1.12" \
        "dbt-postgres>=1.10.0,<1.11"
