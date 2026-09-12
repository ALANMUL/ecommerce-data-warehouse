select
    pr.promo_id,
    pr.promo_name,
    pr.discount_pct,
    pr.promo_duration_days,
    count(distinct oi.order_id) as orders,
    sum(oi.quantity) as units_sold,
    sum(oi.line_total) as revenue,
    sum(oi.gross_margin) as gross_margin
from {{ ref('fact_order_items') }} oi
join {{ ref('dim_promotion') }} pr on oi.promo_id = pr.promo_id
group by 1, 2, 3, 4
