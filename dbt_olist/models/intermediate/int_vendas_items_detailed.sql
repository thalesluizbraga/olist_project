with order_items as (
    select 
     id_pedido,
     numero_item,
     id_produto,
     id_vendedor,
     data_limite_envio,
     valor_item,
     valor_frete
    from {{ ref('staging_order_items') }}
),

sellers as (
    select 
    id_vendedor,
    cep_prefixo,
    cidade,
    uf
    from {{ ref('staging_sellers') }}
),

products as (
    select
    id_produto,
    categoria,
    nome_comprimento,
    descricao_comprimento,
    quantidade_fotos,
    peso_gramas,
    comprimento_cm,
    altura_cm,
    largura_cm 
    from {{ ref('staging_products') }}
),

orders as (
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


items_detailed as (
    
    select
        
        a.id_pedido,
        a.numero_item,
        a.id_produto,
        a.id_vendedor,
        d.id_cliente_pedido,
        b.cidade as vendedor_cidade,
        b.uf as vendedor_uf,
        
        c.categoria as produto_categoria,
        c.peso_gramas,
        c.comprimento_cm,
        c.altura_cm,
        c.largura_cm,
        
        a.valor_item,
        a.valor_frete,
        a.data_limite_envio, 

        d.data_compra

    from order_items a
    left join sellers b on a.id_vendedor = b.id_vendedor
    left join products c on a.id_produto = c.id_produto
    left join orders d on a.id_pedido = d.id_pedido
)

select * from items_detailed