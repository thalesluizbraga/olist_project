# Projeto dbt Olist — transformações sobre schema `raw`.

Documentação completa: [docs/SETUP.md](../docs/SETUP.md)

## Desenvolvimento local

```bash
cd 3-dbt/dbt_olist
dbt debug
dbt run
dbt test
```

## Camadas

| Pasta | Materialização | Função |
|-------|----------------|--------|
| `models/1_staging/` | view | Limpeza de `raw.*` |
| `models/2_intermediate/` | view | Joins e enriquecimento |
| `models/3_marts/` | table | Dimensões e fatos para BI |

## Sincronização com Airflow

Ao alterar modelos aqui, copie para `4-airflow/dbt_olist/` (espelho usado pela DAG).
