with source as (
    select * from olist_dw.raw_order_items
),

renamed as (
    select
        cast(order_id as string) as id_pedido,
        cast(order_item_id as int64) as numero_item,
        cast(product_id as string) as id_produto,
        cast(seller_id as string) as id_vendedor,
        cast(shipping_limit_date as timestamp) as data_limite_envio,
        cast(price as numeric) as valor_item,
        cast(freight_value as numeric) as valor_frete
    from source
)

select * from renamed