with customers as (

select 
id_cliente_pedido,
id_unico_cliente,
cep_prefixo,
cidade,
uf
from 
{{ ref('staging__customers')}}

)

select 
* 
from
customers