with source as (
    select * from olist_dw.raw_orders
),

renamed as (
    select
        cast(order_id as string) as id_pedido,
        cast(customer_id as string) as id_cliente_pedido,
        lower(trim(order_status)) as status_pedido,
        -- Conversão de datas
        cast(order_purchase_timestamp as timestamp) as data_compra,
        cast(order_approved_at as timestamp) as data_aprovacao,
        cast(order_delivered_carrier_date as timestamp) as data_envio_transportadora,
        cast(order_delivered_customer_date as timestamp) as data_entrega_cliente,
        cast(order_estimated_delivery_date as timestamp) as data_estimada_entrega
    from source
)

select * from renamed