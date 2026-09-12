with source as (
    select * from {{ source('raw_ecommerce', 'shipments') }}
),

renamed as (
    select
        shipment_id,
        order_id,
        warehouse_id,
        carrier,
        shipping_mode,
        cast(order_date as date) as order_date,
        cast(ship_date as date) as ship_date,
        cast(estimated_delivery_date as date) as estimated_delivery_date,
        cast(delivery_date as date) as delivery_date,
        status,
        delivery_status,
        cast(n_items as int64) as n_items,
        cast(weight as float64) as weight,
        cast(shipping_cost as float64) as shipping_cost,
        tracking_number,
        cast(delivery_attempts as int64) as delivery_attempts,
        nullif(failure_reason, '') as failure_reason,
        date_diff(delivery_date, estimated_delivery_date, day) as delivery_delay_days,
        date_diff(ship_date, order_date, day) as processing_days
    from source
)

select * from renamed
