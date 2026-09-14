with products as (
    select * from {{ ref('stg_products') }}
),

suppliers as (
    select supplier_id, supplier_name, country from {{ ref('stg_suppliers') }}
),

valid_orders as (
    select order_id
    from {{ ref('stg_orders') }}
    where order_status not in ('CANCELED')
),

product_revenue as (
    select
        oi.product_id,
        sum(oi.line_total) as total_revenue
    from {{ ref('stg_order_items') }} oi
    inner join valid_orders vo on oi.order_id = vo.order_id
    group by oi.product_id
),

ranked as (
    select
        p.product_id,
        coalesce(r.total_revenue, 0) as total_revenue,
        sum(coalesce(r.total_revenue, 0)) over (
            order by coalesce(r.total_revenue, 0) desc, p.product_id
        ) as cumulative_revenue,
        sum(coalesce(r.total_revenue, 0)) over () as grand_total_revenue
    from products p
    left join product_revenue r on p.product_id = r.product_id
),

classified as (
    select
        product_id,
        case
            when safe_divide(cumulative_revenue, nullif(grand_total_revenue, 0)) <= 0.80 then 'A'
            when safe_divide(cumulative_revenue, nullif(grand_total_revenue, 0)) <= 0.95 then 'B'
            else 'C'
        end as abc_class
    from ranked
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
        p.is_active,
        c.abc_class
    from products p
    left join suppliers s on p.supplier_id = s.supplier_id
    left join classified c on p.product_id = c.product_id
)

select * from final