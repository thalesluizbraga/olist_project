with source as (
    select * from olist_dw.raw_products
),

renamed as (
    select
        cast(product_id as string) as id_produto,
        lower(trim(product_category_name)) as categoria,
        cast(product_name_lenght as int64) as nome_comprimento,
        cast(product_description_lenght as int64) as descricao_comprimento,
        cast(product_photos_qty as int64) as quantidade_fotos,
        cast(product_weight_g as numeric) as peso_gramas,
        cast(product_length_cm as numeric) as comprimento_cm,
        cast(product_height_cm as numeric) as altura_cm,
        cast(product_width_cm as numeric) as largura_cm
    from source
)

select * from renamed