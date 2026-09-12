with customers as (
    select * from {{ ref('stg_customers') }}
),

order_stats as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        count(distinct order_id) as lifetime_orders,
        sum(order_total) as lifetime_revenue
    from {{ ref('stg_orders') }}
    where order_status not in ('CANCELLED')
    group by customer_id
),

final as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.signup_date,
        c.region,
        c.city,
        c.state,
        c.zipcode,
        c.channel,
        c.acquisition_cost,
        c.is_active,
        c.churned_date,
        date_trunc(c.signup_date, month) as signup_cohort_month,
        o.first_order_date,
        o.last_order_date,
        coalesce(o.lifetime_orders, 0) as lifetime_orders,
        coalesce(o.lifetime_revenue, 0) as lifetime_revenue
    from customers c
    left join order_stats o on c.customer_id = o.customer_id
)

select * from final
