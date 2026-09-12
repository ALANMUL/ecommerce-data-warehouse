-- sql/raw/purchase_orders_raw.sql
-- Raw table DDL for purchase_orders, loaded from data/purchase_orders.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.purchase_orders` (
  po_id                    STRING,
  supplier_id              STRING,
  product_id               STRING,
  warehouse_id             STRING,
  order_date               DATE,
  expected_delivery_date   DATE,
  received_date            DATE,
  qty_ordered              INT64,
  qty_received             INT64,
  unit_cost                FLOAT64,
  total_value              FLOAT64,
  actual_lead_days         INT64,
  status                   STRING
);
