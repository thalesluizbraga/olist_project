with order_items as (
    select * from {{ ref('staging_order_items') }}
),

sellers as (
    select * from {{ ref('staging_sellers') }}
),

products as (
    select * from {{ ref('staging_products') }}
),

items_detailed as (
    
    select
        
        a.id_pedido,
        a.numero_item,
        a.id_produto,
        a.id_vendedor,

        b.cidade as vendedor_cidade,
        b.uf as vendedor_uf,
        
        c.categoria as produto_categoria,
        c.peso_gramas,
        c.comprimento_cm,
        c.altura_cm,
        c.largura_cm,
        
        a.valor_item,
        a.valor_frete,
        a.data_limite_envio

    from order_items a
    left join sellers b on a.id_vendedor = b.id_vendedor
    left join products c on a.id_produto = c.id_produto
)

select * from items_detailed