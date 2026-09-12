-- sql/raw/promotions_raw.sql
-- Raw table DDL for promotions, loaded from data/promotions.csv

CREATE TABLE IF NOT EXISTS `raw_ecommerce.promotions` (
  promo_id       STRING,
  promo_name     STRING,
  start_date     DATE,
  end_date       DATE,
  discount_pct   FLOAT64
);
