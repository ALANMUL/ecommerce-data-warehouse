-- sql/raw/orders_raw.sql
-- Raw table DDL for orders, loaded from data/orders.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.orders` (
  order_id              STRING,
  customer_id           STRING,
  order_date            DATE,
  order_status          STRING,
  region                STRING,
  primary_warehouse_id  STRING,
  order_subtotal        FLOAT64,
  discount_amount       FLOAT64,
  shipping_cost         FLOAT64,
  tax_amount            FLOAT64,
  order_total           FLOAT64,
  payment_method        STRING,
  promo_id              STRING,
  cancelled_date        DATE,
  cancel_reason         STRING
);
