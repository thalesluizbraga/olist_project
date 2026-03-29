with source as (
    select * from olist_dw.raw_payments
),

renamed as (
    select
        cast(order_id as string) as id_pedido,
        cast(payment_sequential as int64) as sequencial_pagamento,
        lower(trim(payment_type)) as metodo_pagamento,
        cast(payment_installments as int64) as quantidade_parcelas,
        cast(payment_value as numeric) as valor_pagamento
    from source
)

select * from renamed