with customers as (

select 
id_cliente_pedido,
id_unico_cliente,
cep_prefixo,
cidade,
uf
from 
{{ ref('int_customers') }}

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
a.id_unico_cliente,
min(b.data_compra) as data_primeira_compra,
max(b.data_compra) as data_ultima_compra,
count(b.id_pedido) as qtd_compras, 
sum(b.valor_item) as receita, 
b.produto_categoria
from 
customers as a 
left join 
int_vendas_items_detailed as b on a.id_unico_cliente = b.id_cliente_pedido
group by all

)

select 
* 
from 
final
