with source as (
    select * from {{ source('raw_ecommerce', 'products') }}
),

renamed as (
    select
        product_id,
        sku,
        product_name,
        brand,
        category,
        supplier_id,
        cast(cost as float64) as cost,
        cast(base_price as float64) as base_price,
        cast(weight_kg as float64) as weight_kg,
        cast(launch_date as date) as launch_date,
        cast(discontinued_date as date) as discontinued_date,
        cast(is_active as int64) as is_active,
        safe_divide(base_price - cost, nullif(base_price, 0)) as margin_pct
    from source
)

select * from renamed
