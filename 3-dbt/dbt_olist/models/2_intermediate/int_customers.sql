with customers as (
    select
        id_cliente_pedido,
        id_unico_cliente,
        cep_prefixo,
        cidade,
        uf
    from {{ ref('staging_customers') }}
)

select * from customers
