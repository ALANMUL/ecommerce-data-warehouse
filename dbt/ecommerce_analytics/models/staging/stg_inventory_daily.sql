with source as (
    select * from {{ source('raw_ecommerce', 'inventory_daily') }}
),

renamed as (
    select
        cast(date as date) as inventory_date,
        product_id,
        warehouse_id,
        supplier_id,
        region,
        cast(units_sold as int64) as units_sold,
        cast(inventory_level as int64) as inventory_level,
        cast(supplier_lead_time_days as int64) as supplier_lead_time_days,
        cast(reorder_point as int64) as reorder_point,
        cast(safety_stock as int64) as safety_stock,
        cast(order_quantity as int64) as order_quantity,
        cast(unit_cost as float64) as unit_cost,
        cast(unit_price as float64) as unit_price,
        cast(promotion_flag as int64) as promotion_flag,
        cast(stockout_flag as int64) as stockout_flag,
        cast(lost_sales_qty as int64) as lost_sales_qty,
        cast(demand_forecast as float64) as demand_forecast,
        cast(days_of_cover as float64) as days_of_cover
    from source
)

select * from renamed
