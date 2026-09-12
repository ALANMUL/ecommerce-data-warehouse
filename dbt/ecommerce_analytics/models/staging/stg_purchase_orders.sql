with source as (
    select * from {{ source('raw_ecommerce', 'purchase_orders') }}
),

renamed as (
    select
        po_id,
        supplier_id,
        product_id,
        warehouse_id,
        cast(order_date as date) as order_date,
        cast(expected_delivery_date as date) as expected_delivery_date,
        cast(received_date as date) as received_date,
        cast(qty_ordered as int64) as qty_ordered,
        cast(qty_received as int64) as qty_received,
        cast(unit_cost as float64) as unit_cost,
        cast(total_value as float64) as total_value,
        cast(actual_lead_days as int64) as actual_lead_days,
        status,
        qty_ordered - qty_received as qty_shortfall,
        date_diff(received_date, expected_delivery_date, day) as days_late
    from source
)

select * from renamed
