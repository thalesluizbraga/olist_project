with sellers as (

select 
    id_vendedor,
    cep_prefixo,
    cidade,
    uf
from 
{{ ref('int_sellers') }}

), 

int_vendas_items_detailed as (

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
{{ref('int_vendas_items_detailed')}}

), 

final as (

select 
a.id_vendedor,
min(b.data_compra) as data_primeira_venda,
max(b.data_compra) as data_ultima_venda,
count(b.id_pedido) as qtd_vendas, 
sum(b.valor_item) as receita
from 
sellers as a 
left join 
int_vendas_items_detailed as b on a.id_vendedor = b.id_vendedor
group by all

)

select 
* 
from 
final
