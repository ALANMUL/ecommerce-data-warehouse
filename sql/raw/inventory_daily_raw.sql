-- sql/raw/inventory_daily_raw.sql
-- Raw table DDL for inventory_daily, loaded from data/inventory_daily.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.inventory_daily` (
  date                      DATE,
  product_id                STRING,
  warehouse_id              STRING,
  supplier_id               STRING,
  region                    STRING,
  units_sold                INT64,
  inventory_level           INT64,
  supplier_lead_time_days   INT64,
  reorder_point             INT64,
  safety_stock              INT64,
  order_quantity            INT64,
  unit_cost                 FLOAT64,
  unit_price                FLOAT64,
  promotion_flag            INT64,
  stockout_flag             INT64,
  lost_sales_qty            INT64,
  demand_forecast           FLOAT64,
  days_of_cover             FLOAT64
);
