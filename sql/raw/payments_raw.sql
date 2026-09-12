-- sql/raw/payments_raw.sql
-- Raw table DDL for payments, loaded from data/payments.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.payments` (
  payment_id        STRING,
  order_id          STRING,
  payment_method    STRING,
  amount            FLOAT64,
  status            STRING,
  transaction_date  DATE,
  failure_reason    STRING,
  refund_amount     FLOAT64
);
