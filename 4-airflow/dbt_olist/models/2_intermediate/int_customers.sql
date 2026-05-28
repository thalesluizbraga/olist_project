-- Pass-through da staging; usado por dim_customers e outros marts
with customers as (
    select
        id_cliente_pedido,
        id_unico_cliente,
        cep_prefixo,
        cidade,
        uf
    from {{ ref('staging_customers') }}  -- camada 1_staging
)

select * from customers
