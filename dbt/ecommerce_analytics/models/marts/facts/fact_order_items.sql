select
    order_id,
    customer_id,
    order_date,
    product_id,
    warehouse_id,
    quantity,
    unit_price,
    discount_pct,
    line_total,
    unit_cost,
    gross_margin,
    promo_id
from {{ ref('int_product_sales') }}
