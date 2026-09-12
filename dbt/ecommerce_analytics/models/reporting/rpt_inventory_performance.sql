-- Supply chain: stockout exposure & inventory health by product/warehouse.
select
    product_id,
    warehouse_id,
    count(*) as days_tracked,
    sum(stockout_flag) as stockout_days,
    safe_divide(sum(stockout_flag), count(*)) as stockout_rate,
    sum(lost_sales_qty) as total_lost_sales_qty,
    sum(lost_sales_value) as total_lost_sales_value,
    avg(inventory_level) as avg_inventory_level,
    avg(days_of_cover) as avg_days_of_cover,
    sum(below_reorder_point_flag) as days_below_reorder_point,
    avg(demand_forecast) as avg_demand_forecast,
    sum(units_sold) as total_units_sold
from {{ ref('fact_inventory') }}
group by 1, 2
