with source as (
    select * from {{ source('raw_ecommerce', 'order_items') }}
),

renamed as (
    select
        order_id,
        product_id,
        cast(quantity as int64) as quantity,
        cast(unit_price as float64) as unit_price,
        cast(discount_pct as float64) as discount_pct,
        cast(line_total as float64) as line_total,
        warehouse_id,
        nullif(promo_id, '') as promo_id
    from source
)

select * from renamed
