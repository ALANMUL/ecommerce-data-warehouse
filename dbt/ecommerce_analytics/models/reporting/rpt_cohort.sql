-- Monthly acquisition cohort retention analysis.
with orders as (
    select customer_id, order_date, order_total
    from {{ ref('fact_orders') }}
    where order_status not in ('CANCELLED')
),

first_order as (
    select
        customer_id,
        date_trunc(min(order_date), month) as cohort_month
    from orders
    group by customer_id
),

activity as (
    select
        o.customer_id,
        f.cohort_month,
        date_trunc(o.order_date, month) as activity_month,
        o.order_total
    from orders o
    join first_order f on o.customer_id = f.customer_id
),

cohort_activity as (
    select
        cohort_month,
        activity_month,
        date_diff(activity_month, cohort_month, month) as period_number,
        count(distinct customer_id) as active_customers,
        sum(order_total) as cohort_revenue
    from activity
    group by cohort_month, activity_month
),

cohort_size as (
    select cohort_month, count(distinct customer_id) as cohort_customers
    from first_order
    group by cohort_month
)

select
    ca.cohort_month,
    cs.cohort_customers,
    ca.activity_month,
    ca.period_number,
    ca.active_customers,
    ca.cohort_revenue,
    safe_divide(ca.active_customers, cs.cohort_customers) as retention_rate,
    safe_divide(ca.cohort_revenue, cs.cohort_customers) as revenue_per_cohort_customer
from cohort_activity ca
join cohort_size cs on ca.cohort_month = cs.cohort_month
order by ca.cohort_month, ca.period_number
