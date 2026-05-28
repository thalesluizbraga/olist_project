with source as (
    select * from {{ source('olist', 'raw_order_payments') }}
),

renamed as (
    select
        order_id::text as id_pedido,
        payment_sequential::integer as sequencial_pagamento,
        lower(trim(payment_type)) as metodo_pagamento,
        payment_installments::integer as quantidade_parcelas,
        payment_value::numeric as valor_pagamento
    from source
)

select * from renamed
