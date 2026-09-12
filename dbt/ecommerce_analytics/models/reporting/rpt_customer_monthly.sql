-- Customer x month activity grid, useful for churn / engagement BI views.
select
    customer_id,
    date_trunc(order_date, month) as month,
    count(distinct order_id) as orders,
    sum(order_total) as revenue,
    sum(return_count) as returns,
    sum(return_refund_amount) as refund_amount
from {{ ref('fact_orders') }}
group by customer_id, month
