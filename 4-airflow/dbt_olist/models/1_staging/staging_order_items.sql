with source as (
    select * from {{ source('olist', 'raw_order_items') }}
),

renamed as (
    select
        order_id::text as id_pedido,
        order_item_id::integer as numero_item,
        product_id::text as id_produto,
        seller_id::text as id_vendedor,
        shipping_limit_date::timestamp as data_limite_envio,
        price::numeric as valor_item,
        freight_value::numeric as valor_frete
    from source
)

select * from renamed
