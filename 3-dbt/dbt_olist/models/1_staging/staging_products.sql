with source as (
    select * from {{ source('olist', 'raw_olist_products_dataset') }}
),

renamed as (
    select
        product_id::text as id_produto,
        lower(trim(product_category_name)) as categoria,
        product_name_lenght::integer as nome_comprimento,
        product_description_lenght::integer as descricao_comprimento,
        product_photos_qty::integer as quantidade_fotos,
        product_weight_g::numeric as peso_gramas,
        product_length_cm::numeric as comprimento_cm,
        product_height_cm::numeric as altura_cm,
        product_width_cm::numeric as largura_cm
    from source
)

select * from renamed
