with shipments as (
    select * from {{ ref('stg_shipments') }}
),

orders as (
    select order_id, customer_id, region from {{ ref('stg_orders') }}
),

final as (
    select
        s.*,
        o.customer_id,
        o.region as customer_region,
        case when s.delivery_delay_days > 0 then 1 else 0 end as is_late_delivery,
        case when s.delivery_status = 'Delivered' or s.status = 'Delivered' then 1 else 0 end as is_delivered
    from shipments s
    left join orders o on s.order_id = o.order_id
)

select * from final
