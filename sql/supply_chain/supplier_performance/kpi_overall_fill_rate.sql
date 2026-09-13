SELECT
  ROUND(SUM(qty_received) / SUM(qty_ordered) * 100, 1) AS overall_fill_rate_pct
FROM `tokyo-bird-508406-v7.dbt_dev_reporting.rpt_supplier_performance`
