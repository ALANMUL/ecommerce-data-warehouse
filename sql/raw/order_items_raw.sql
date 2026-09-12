-- sql/raw/order_items_raw.sql
-- Raw table DDL for order_items, loaded from data/order_items.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.order_items` (
  order_id       STRING,
  product_id     STRING,
  quantity       INT64,
  unit_price     FLOAT64,
  discount_pct   FLOAT64,
  line_total     FLOAT64,
  warehouse_id   STRING,
  promo_id       STRING
);
