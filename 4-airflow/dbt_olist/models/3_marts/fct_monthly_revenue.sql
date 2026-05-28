-- Fato mensal de receita — consumido pelo Power BI
-- Depende de int_vendas_items_detailed (camada intermediate)

with vendas as (
    select *
    from {{ ref('int_vendas_items_detailed') }}
),

final as (
    select
        date_trunc('month', data_compra)::date as mes,
        sum(valor_item) as receita,
        sum(valor_frete) as frete,
        sum(valor_item) - sum(valor_frete) as receita_liquida
    from vendas
    where data_compra is not null
    group by date_trunc('month', data_compra)::date
)

select * from final
