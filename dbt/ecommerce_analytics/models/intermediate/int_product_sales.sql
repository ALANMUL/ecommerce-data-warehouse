-- Order-item grain sales enriched with product & promo attributes.
with order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select order_id, customer_id, order_date, order_status, region
    from {{ ref('stg_orders') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

promotions as (
    select promo_id, promo_name, discount_pct as promo_discount_pct
    from {{ ref('stg_promotions') }}
),

final as (
    select
        oi.order_id,
        o.customer_id,
        o.order_date,
        o.order_status,
        o.region,
        oi.product_id,
        p.product_name,
        p.brand,
        p.category,
        p.supplier_id,
        oi.warehouse_id,
        oi.quantity,
        oi.unit_price,
        oi.discount_pct,
        oi.line_total,
        p.cost as unit_cost,
        (oi.unit_price - p.cost) * oi.quantity as gross_margin,
        oi.promo_id,
        pr.promo_name
    from order_items oi
    left join orders o on oi.order_id = o.order_id
    left join products p on oi.product_id = p.product_id
    left join promotions pr on oi.promo_id = pr.promo_id
)

select * from final
