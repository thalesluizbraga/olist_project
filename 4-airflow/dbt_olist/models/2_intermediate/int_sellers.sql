with sellers as (
    select
        id_vendedor,
        cep_prefixo,
        cidade,
        uf
    from {{ref('staging_sellers')}}
)

select * from sellers