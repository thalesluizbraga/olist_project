with products as (

    select
        id_produto,
        categoria,
        nome_comprimento,
        descricao_comprimento,
        quantidade_fotos,
        peso_gramas,
        comprimento_cm,
        altura_cm,
        largura_cm
    from {{ ref('staging_products') }}
)

select * from products