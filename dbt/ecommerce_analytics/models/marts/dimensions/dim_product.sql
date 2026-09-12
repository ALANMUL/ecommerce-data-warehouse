with products as (
    select * from {{ ref('stg_products') }}
),

suppliers as (
    select supplier_id, supplier_name, country from {{ ref('stg_suppliers') }}
),

final as (
    select
        p.product_id,
        p.sku,
        p.product_name,
        p.brand,
        p.category,
        p.supplier_id,
        s.supplier_name,
        s.country as supplier_country,
        p.cost,
        p.base_price,
        p.margin_pct,
        p.weight_kg,
        p.launch_date,
        p.discontinued_date,
        p.is_active
    from products p
    left join suppliers s on p.supplier_id = s.supplier_id
)

select * from final
