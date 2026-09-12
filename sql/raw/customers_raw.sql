-- sql/raw/customers_raw.sql
-- Raw table DDL for customers, loaded from data/customers.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.customers` (
  customer_id      STRING,
  first_name       STRING,
  last_name        STRING,
  email            STRING,
  signup_date      DATE,
  region           STRING,
  city             STRING,
  state            STRING,
  zipcode          STRING,   -- kept as STRING to preserve leading zeros
  channel          STRING,
  acquisition_cost FLOAT64,
  is_active        INT64,
  churned_date     DATE
);
