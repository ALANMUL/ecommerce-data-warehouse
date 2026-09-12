-- Executive KPI summary, monthly grain, for a BI dashboard landing page.
with orders as (
    select * from {{ ref('fact_orders') }} where order_status not in ('CANCELLED')
),

order_items as (
    select * from {{ ref('fact_order_items') }}
),

returns as (
    select * from {{ ref('fact_returns') }}
),

monthly_orders as (
    select
        date_trunc(order_date, month) as month,
        count(distinct order_id) as orders,
        count(distinct customer_id) as active_customers,
        sum(order_total) as revenue,
        sum(discount_amount) as total_discount,
        sum(shipping_cost) as total_shipping_cost,
        avg(order_total) as avg_order_value
    from orders
    group by month
),

monthly_margin as (
    select
        date_trunc(order_date, month) as month,
        sum(gross_margin) as gross_margin,
        sum(line_total) as items_revenue
    from order_items
    group by month
),

monthly_returns as (
    select
        date_trunc(return_date, month) as month,
        count(distinct return_id) as return_count,
        sum(refund_amount) as return_refund_amount
    from returns
    group by month
),

new_customers as (
    select
        signup_cohort_month as month,
        count(distinct customer_id) as new_customers
    from {{ ref('dim_customer') }}
    group by month
)

select
    o.month,
    o.orders,
    o.active_customers,
    o.revenue,
    o.total_discount,
    o.total_shipping_cost,
    o.avg_order_value,
    m.gross_margin,
    safe_divide(m.gross_margin, nullif(m.items_revenue, 0)) as gross_margin_pct,
    coalesce(r.return_count, 0) as return_count,
    coalesce(r.return_refund_amount, 0) as return_refund_amount,
    safe_divide(r.return_count, nullif(o.orders, 0)) as return_rate,
    coalesce(n.new_customers, 0) as new_customers
from monthly_orders o
left join monthly_margin m on o.month = m.month
left join monthly_returns r on o.month = r.month
left join new_customers n on o.month = n.month
order by o.month
