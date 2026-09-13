SELECT
  ROUND(AVG(avg_actual_lead_days - avg_contracted_lead_days), 1) AS avg_lead_time_variance_days
FROM `tokyo-bird-508406-v7.dbt_dev_reporting.rpt_supplier_performance`
