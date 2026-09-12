with returns as (
    select * from {{ ref('stg_returns') }}
),

products as (
    select product_id, product_name, category, brand from {{ ref('stg_products') }}
),

final as (
    select
        r.*,
        p.product_name,
        p.category,
        p.brand
    from returns r
    left join products p on r.product_id = p.product_id
)

select * from final
