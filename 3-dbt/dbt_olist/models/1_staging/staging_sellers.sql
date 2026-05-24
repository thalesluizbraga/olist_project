with source as (
    select * from {{ source('olist', 'raw_sellers') }}
),

renamed as (
    select
        seller_id::text as id_vendedor,
        seller_zip_code_prefix::integer as cep_prefixo,
        lower(trim(seller_city)) as cidade,
        upper(trim(seller_state)) as uf
    from source
)

select * from renamed
