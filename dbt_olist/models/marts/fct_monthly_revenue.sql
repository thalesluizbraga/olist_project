with vendas as (

select 
*
from 
{{  ref ('int_vendas_items_detailed') }}

), 

final as (


select 
cast(date_trunc(data_compra, month) as date) as mes,
sum(valor_item) as receita,
sum(valor_frete) as frete,
sum(valor_item) - sum(valor_frete) as receita_liquida  
from 
vendas
group by all 

)

select 
*
from 
final