SELECT
  ROUND(100 - AVG(pct_late_orders), 1) AS on_time_delivery_rate_pct
FROM `tokyo-bird-508406-v7.dbt_dev_reporting.rpt_supplier_performance`
