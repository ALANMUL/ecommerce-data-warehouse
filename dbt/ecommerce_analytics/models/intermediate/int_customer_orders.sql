-- One row per order, enriched with payment + return signals, for RFM/cohort/BI use.
with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select
        order_id,
        sum(amount) as total_paid,
        sum(refund_amount) as total_refunded,
        max(status) as last_payment_status
    from {{ ref('stg_payments') }}
    group by order_id
),

returns as (
    select
        order_id,
        count(distinct return_id) as return_count,
        sum(refund_amount) as return_refund_amount
    from {{ ref('stg_returns') }}
    group by order_id
),

final as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.order_status,
        o.region,
        o.primary_warehouse_id,
        o.order_subtotal,
        o.discount_amount,
        o.shipping_cost,
        o.tax_amount,
        o.order_total,
        o.payment_method,
        o.promo_id,
        o.cancelled_date,
        o.cancel_reason,
        coalesce(p.total_paid, 0) as total_paid,
        coalesce(p.total_refunded, 0) as total_refunded,
        p.last_payment_status,
        coalesce(r.return_count, 0) as return_count,
        coalesce(r.return_refund_amount, 0) as return_refund_amount,
        case when o.order_status = 'COMPLETE' then 1 else 0 end as is_completed_order
    from orders o
    left join payments p on o.order_id = p.order_id
    left join returns r on o.order_id = r.order_id
)

select * from final
