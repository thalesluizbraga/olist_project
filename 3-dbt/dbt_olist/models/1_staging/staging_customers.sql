with source as (
    select * from {{ source('olist', 'raw_customers') }}
),

renamed as (
    select
        customer_id::text as id_cliente_pedido,
        customer_unique_id::text as id_unico_cliente,
        customer_zip_code_prefix::integer as cep_prefixo,
        lower(trim(customer_city)) as cidade,
        upper(trim(customer_state)) as uf
    from source
)

select * from renamed
