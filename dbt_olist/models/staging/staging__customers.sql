with source as (
    select * from olist_dw.raw_customers

),

renamed as (
    select
        cast(customer_id as string) as id_cliente_pedido,
        cast(customer_unique_id as string) as id_unico_cliente,
        cast(customer_zip_code_prefix as int64) as cep_prefixo,
        lower(trim(customer_city)) as cidade,
        upper(trim(customer_state)) as uf
    from source
)

select * from renamed