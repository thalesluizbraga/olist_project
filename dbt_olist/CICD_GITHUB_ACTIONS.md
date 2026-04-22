# CI/CD no GitHub Actions (dbt_olist)

Este documento define uma esteira de CI/CD para o projeto `dbt_olist` usando GitHub Actions.
O objetivo e garantir qualidade no `pull request` (CI) e publicar artefatos de execucao em `main` (CD).

## 1) Objetivos da esteira

- Validar alteracoes de modelos dbt antes do merge.
- Detectar erros de configuracao com `dbt debug`.
- Executar `dbt run` e `dbt test` em ambiente de CI.
- Publicar artefatos (`manifest.json`, `run_results.json`) para auditoria.

## 2) Estrategia de branch e gatilhos

- `pull_request` para `main`: executa CI completo (qualidade + build + testes).
- `push` em `main`: executa CI/CD e publica artefatos.
- `workflow_dispatch`: permite execucao manual (ex.: reprocessamento).

## 3) Variaveis e secrets necessarios

Configurar no repositorio (`Settings > Secrets and variables > Actions`):

### Secrets

- `GCP_SERVICE_ACCOUNT_KEY`: JSON da service account do BigQuery (conteudo completo).

### Variables (ou Secrets, se preferir)

- `DBT_METHOD` (ex.: `service-account`)
- `DBT_PROJECT`
- `DBT_DATASET`
- `DBT_LOCATION` (ex.: `US`)
- `DBT_THREADS` (ex.: `4`)
- `DBT_PRIORITY` (ex.: `interactive`)
- `DBT_JOB_TIMEOUT` (ex.: `300`)
- `DBT_JOB_RETRIES` (ex.: `1`)

> O `profiles.yml` do projeto ja espera essas variaveis via `env_var(...)`.

## 4) Workflow recomendado

Criar o arquivo `.github/workflows/dbt-ci-cd.yml` com o conteudo abaixo:

```yaml
name: dbt CI/CD

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  dbt:
    runs-on: ubuntu-latest

    defaults:
      run:
        shell: bash
        working-directory: dbt_olist

    env:
      DBT_METHOD: ${{ vars.DBT_METHOD }}
      DBT_PROJECT: ${{ vars.DBT_PROJECT }}
      DBT_DATASET: ${{ vars.DBT_DATASET }}
      DBT_LOCATION: ${{ vars.DBT_LOCATION }}
      DBT_THREADS: ${{ vars.DBT_THREADS }}
      DBT_PRIORITY: ${{ vars.DBT_PRIORITY }}
      DBT_JOB_TIMEOUT: ${{ vars.DBT_JOB_TIMEOUT }}
      DBT_JOB_RETRIES: ${{ vars.DBT_JOB_RETRIES }}
      DBT_KEYFILE_PATH: /tmp/gcp-key.json

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install uv
        uses: astral-sh/setup-uv@v3

      - name: Install dependencies
        run: uv sync --frozen

      - name: Prepare GCP key
        run: echo '${{ secrets.GCP_SERVICE_ACCOUNT_KEY }}' > /tmp/gcp-key.json

      - name: dbt deps
        run: uv run dbt deps

      - name: dbt debug
        run: uv run dbt debug --profiles-dir .

      - name: dbt run
        run: uv run dbt run --profiles-dir .

      - name: dbt test
        run: uv run dbt test --profiles-dir .

      - name: Upload dbt artifacts
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: dbt-artifacts
          path: |
            dbt_olist/target/manifest.json
            dbt_olist/target/run_results.json
```

## 5) Boas praticas de operacao

- Use `pull request` pequeno para acelerar feedback do CI.
- Em caso de falha, validar localmente com:
  - `uv sync`
  - `uv run dbt debug --profiles-dir dbt_olist`
  - `uv run dbt run --profiles-dir dbt_olist`
  - `uv run dbt test --profiles-dir dbt_olist`
- Evite commitar credenciais; use somente Secrets do GitHub.
- Monitore custo no BigQuery para jobs recorrentes em `main`.

## 6) Evolucoes recomendadas

- Separar ambientes `dev` e `prod` via targets no `profiles.yml`.
- Adicionar job de `dbt build --select state:modified+` para PR incremental.
- Incluir agendamento com `schedule` para execucoes diarias.
- Publicar documentacao com `dbt docs generate` + Pages (opcional).
