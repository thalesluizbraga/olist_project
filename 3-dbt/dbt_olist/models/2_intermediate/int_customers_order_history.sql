with orders as (
    select 
    id_pedido,
    id_cliente_pedido,
    status_pedido,
    data_compra,
    data_aprovacao,
    data_envio_transportadora,
    data_entrega_cliente,
    data_estimada_entrega 
    from {{ ref('staging_orders') }}
),

customers_order_history as (
    select
        id_cliente_pedido,
        min(data_compra) as data_primeira_compra,
        max(data_compra) as data_ultima_compra
    from orders
    where data_compra is not null
    group by id_cliente_pedido
)

select * from customers_order_history
