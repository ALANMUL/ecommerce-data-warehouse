SELECT
  supplier_name,
  fill_rate
FROM `tokyo-bird-508406-v7.dbt_dev_reporting.rpt_supplier_performance`
ORDER BY fill_rate DESC
