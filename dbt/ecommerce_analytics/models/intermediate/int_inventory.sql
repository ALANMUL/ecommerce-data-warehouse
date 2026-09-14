-- Daily inventory position enriched with product/warehouse/supplier attributes.
with inv as (
    select * from {{ ref('stg_inventory_daily') }}
),

products as (
    select product_id, product_name, category, brand from {{ ref('stg_products') }}
),

warehouses as (
    select warehouse_id, warehouse_name, warehouse_type from {{ ref('stg_warehouses') }}
),

suppliers as (
    select supplier_id, supplier_name, lead_time_mean_days from {{ ref('stg_suppliers') }}
),

final as (
    select
        i.inventory_date,
        i.product_id,
        p.product_name,
        p.category,
        p.brand,
        i.warehouse_id,
        w.warehouse_name,
        w.warehouse_type,
        i.supplier_id,
        s.supplier_name,
        i.region,
        i.units_sold,
        i.inventory_level,
        i.supplier_lead_time_days,
        i.reorder_point,
        i.safety_stock,
        i.order_quantity,
        i.unit_cost,
        i.unit_price,
        i.promotion_flag,
        i.stockout_flag,
        i.lost_sales_qty,
        i.demand_forecast,
        i.days_of_cover,
        case when i.inventory_level <= i.reorder_point then 1 else 0 end as below_reorder_point_flag,
        i.lost_sales_qty * i.unit_price as lost_sales_value,
        i.inventory_level * i.unit_cost as inventory_value,
        case
            when i.days_of_cover > percentile_cont(i.days_of_cover, 0.9) over ()
            then 1 else 0
        end as excess_inventory_flag
    from inv i
    left join products p on i.product_id = p.product_id
    left join warehouses w on i.warehouse_id = w.warehouse_id
    left join suppliers s on i.supplier_id = s.supplier_id
)

select * from final