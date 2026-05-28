with source as (
    select * from {{ source('olist', 'raw_orders') }}
),

renamed as (
    select
        order_id::text as id_pedido,
        customer_id::text as id_cliente_pedido,
        lower(trim(order_status)) as status_pedido,
        order_purchase_timestamp::timestamp as data_compra,
        order_approved_at::timestamp as data_aprovacao,
        order_delivered_carrier_date::timestamp as data_envio_transportadora,
        order_delivered_customer_date::timestamp as data_entrega_cliente,
        order_estimated_delivery_date::timestamp as data_estimada_entrega
    from source
)

select * from renamed
