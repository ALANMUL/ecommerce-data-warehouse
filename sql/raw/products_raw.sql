-- sql/raw/products_raw.sql
-- Raw table DDL for products, loaded from data/products.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.products` (
  product_id         STRING,
  sku                STRING,
  product_name       STRING,
  brand              STRING,
  category           STRING,
  supplier_id        STRING,
  cost               FLOAT64,
  base_price         FLOAT64,
  weight_kg          FLOAT64,
  launch_date        DATE,
  discontinued_date  DATE,
  is_active          INT64
);
