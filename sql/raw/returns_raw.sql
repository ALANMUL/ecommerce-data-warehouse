-- sql/raw/returns_raw.sql
-- Raw table DDL for returns, loaded from data/returns.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.returns` (
  return_id       STRING,
  order_id        STRING,
  product_id      STRING,
  customer_id     STRING,
  return_date     DATE,
  quantity        INT64,
  reason          STRING,
  refund_amount   FLOAT64,
  condition       STRING,
  restocked_flag  INT64
);
