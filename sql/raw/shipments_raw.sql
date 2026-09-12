-- sql/raw/shipments_raw.sql
-- Raw table DDL for shipments, loaded from data/shipments.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.shipments` (
  shipment_id             STRING,
  order_id                STRING,
  warehouse_id            STRING,
  carrier                 STRING,
  shipping_mode           STRING,
  order_date              DATE,
  ship_date               DATE,
  estimated_delivery_date DATE,
  delivery_date           DATE,
  status                  STRING,
  delivery_status         STRING,
  n_items                 INT64,
  weight                  FLOAT64,
  shipping_cost           FLOAT64,
  tracking_number         STRING,
  delivery_attempts       INT64,
  failure_reason          STRING
);
