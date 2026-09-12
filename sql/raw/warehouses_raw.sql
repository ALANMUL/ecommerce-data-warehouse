-- sql/raw/warehouses_raw.sql
-- Raw table DDL for warehouses, loaded from data/warehouses.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.warehouses` (
  warehouse_id     STRING,
  warehouse_name   STRING,
  city             STRING,
  state            STRING,
  warehouse_type   STRING,
  capacity_units   INT64
);
