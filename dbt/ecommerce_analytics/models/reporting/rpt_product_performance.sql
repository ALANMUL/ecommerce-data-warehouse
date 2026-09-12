select
    oi.product_id,
    p.product_name,
    p.brand,
    p.category,
    p.supplier_name,
    count(distinct oi.order_id) as orders,
    sum(oi.quantity) as units_sold,
    sum(oi.line_total) as revenue,
    sum(oi.gross_margin) as gross_margin,
    safe_divide(sum(oi.gross_margin), nullif(sum(oi.line_total), 0)) as gross_margin_pct,
    coalesce(sum(r.quantity), 0) as units_returned,
    coalesce(sum(r.refund_amount), 0) as return_refund_amount,
    safe_divide(sum(r.quantity), nullif(sum(oi.quantity), 0)) as return_rate
from {{ ref('fact_order_items') }} oi
left join {{ ref('dim_product') }} p on oi.product_id = p.product_id
left join (
    select product_id, sum(quantity) as quantity, sum(refund_amount) as refund_amount
    from {{ ref('fact_returns') }}
    group by product_id
) r on oi.product_id = r.product_id
group by 1, 2, 3, 4, 5
