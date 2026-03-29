with source as (
    select * from olist_dw.raw_sellers
),

renamed as (
    select
        cast(seller_id as string) as id_vendedor,
        cast(seller_zip_code_prefix as int64) as cep_prefixo,
        lower(trim(seller_city)) as cidade,
        upper(trim(seller_state)) as uf
    from source
)

select * from renamed