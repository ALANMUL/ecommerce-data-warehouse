# Ecommerce Data Warehouse — Analytics Portfolio

A single dbt + BigQuery warehouse powering four analytics portfolio projects on a
synthetic ecommerce dataset (customers, orders, inventory, suppliers, shipments, etc.).

## Projects

| # | Project | Where it lives |
|---|---------|-----------------|
| 1 | **RFM Segmentation** | `dbt/.../models/reporting/rpt_rfm.sql` |
| 2 | **Cohort Retention Analysis** | `dbt/.../models/reporting/rpt_cohort.sql` |
| 3 | **Business Intelligence Dashboard** | `rpt_business_summary.sql`, `rpt_customer_monthly.sql`, `rpt_product_performance.sql`, `rpt_promotion_performance.sql` + `06_dashboards/` |
| 4 | **Supply Chain Analytics** | `rpt_supplier_performance.sql`, `rpt_inventory_performance.sql`, `rpt_shipping_performance.sql`, `rpt_returns_analysis.sql` |

## Architecture

```
01_raw_data/        -> CSV source files (also loaded into BigQuery as raw tables)
dbt/ecommerce_analytics/
  models/
    staging/         -> 1:1 cleaned views over raw BigQuery tables (stg_*)
    intermediate/     -> joined/enriched business concepts (int_*)
    marts/
      dimensions/     -> dim_customer, dim_product, dim_supplier, dim_warehouse, dim_date, dim_promotion
      facts/          -> fact_orders, fact_order_items, fact_inventory, fact_purchase_orders,
                          fact_shipments, fact_payments, fact_returns
    reporting/        -> rpt_* — the analysis-ready tables the dashboards / SQL work sit on top of
06_dashboards/       -> Power BI / Metabase / Retool dashboard files
scripts/             -> helper scripts (BigQuery CSV loader)
```

This mirrors the classic staging -> intermediate -> marts -> reporting dbt layering,
so lineage is traceable end to end with `dbt docs generate`.

## Setup

1. **Create a BigQuery project** (or reuse one) and authenticate:
   ```bash
   gcloud auth application-default login
   ```

2. **Load the raw CSVs into BigQuery:**
   ```bash
   PROJECT_ID=your-gcp-project ./scripts/load_raw_to_bigquery.sh
   ```
   This creates a `raw_ecommerce` dataset with one table per CSV.

3. **Configure dbt.** Copy the profile template and fill in your project:
   ```bash
   cp dbt/ecommerce_analytics/profiles.yml.example ~/.dbt/profiles.yml
   ```

4. **Install dbt + dependencies:**
   ```bash
   pip install dbt-bigquery
   cd dbt/ecommerce_analytics
   dbt deps
   ```

5. **Run everything:**
   ```bash
   dbt run
   dbt test
   dbt docs generate && dbt docs serve
   ```

## Data model at a glance

- **Customers / Orders / Order Items / Payments / Returns** — transactional core, feeds RFM, cohort, and BI.
- **Products / Suppliers / Purchase Orders / Inventory Daily / Shipments** — supply-chain core, feeds the supplier scorecard, stockout/inventory analysis, and delivery performance reports.
- **Promotions** — links to orders and order_items via `promo_id`, feeds promotion ROI analysis.

## Notes on the data

The dataset is synthetic (see `01_raw_data/`). Row counts: ~30K customers, ~107K orders,
~165K order lines, ~146K daily inventory snapshots, ~124K shipments, ~773 purchase orders,
~25K returns.
