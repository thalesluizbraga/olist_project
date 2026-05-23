with int_vendas_items_detailed as (

    select   
        id_pedido,
        numero_item,
        id_produto,
        id_vendedor,
        id_cliente_pedido,
        vendedor_cidade,
        vendedor_uf,      
        produto_categoria,
        peso_gramas,
        comprimento_cm,
        altura_cm,
        largura_cm,      
        valor_item,
        valor_frete,
        data_limite_envio, 
        data_compra
    from 
    {{ ref('int_vendas_items_detailed') }} 


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
    from {{ ref('int_products') }} 

), 

final as (

select 
a.id_produto, 
a.categoria,
count(b.id_pedido) as qtd_vendida,
sum(b.valor_item) as valor_vendido,
avg(b.valor_item) as valor_medio_vendido,
sum(b.valor_frete) as valor_frete,
avg(b.valor_frete) as valor_medio_frete
from 
products as a 
left join 
int_vendas_items_detailed as b on a.id_produto = b.id_produto
group by all

)

select 
* 
from 
final