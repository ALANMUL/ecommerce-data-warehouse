-- sql/raw/suppliers_raw.sql
-- Raw table DDL for suppliers, loaded from data/suppliers.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.suppliers` (
  supplier_id          STRING,
  supplier_name        STRING,
  country              STRING,
  currency             STRING,
  payment_terms        STRING,
  lead_time_mean_days  INT64,
  lead_time_cv         FLOAT64,
  min_order_qty        INT64,
  contract_start_date  DATE,
  is_active            INT64
);
