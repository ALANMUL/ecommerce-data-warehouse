with source as (
    select * from {{ source('raw_ecommerce', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        cast(order_date as date) as order_date,
        order_status,
        region,
        primary_warehouse_id,
        cast(order_subtotal as float64) as order_subtotal,
        cast(discount_amount as float64) as discount_amount,
        cast(shipping_cost as float64) as shipping_cost,
        cast(tax_amount as float64) as tax_amount,
        cast(order_total as float64) as order_total,
        payment_method,
        nullif(promo_id, '') as promo_id,
        cast(cancelled_date as date) as cancelled_date,
        nullif(cancel_reason, '') as cancel_reason
    from source
)

select * from renamed
