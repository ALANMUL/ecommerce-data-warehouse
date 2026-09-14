# Creates raw BigQuery tables from explicit DDL (sql/raw/*.sql), then loads
# the CSVs in data/ into those tables. Schema is defined by hand, not
# autodetected, so this must be run after any DDL changes are made.
# Requires: gcloud + bq CLI authenticated (gcloud auth login / application-default login).
#
# Usage:
#   PROJECT_ID=your-gcp-project ./ops/load_raw_to_bigquery.sh

set -euo pipefail

PROJECT_ID="${PROJECT_ID:?Set PROJECT_ID env var to your GCP project id}"
DATASET="${RAW_DATASET:-ecommerce_dataset}"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="${ROOT_DIR}/data"
DDL_DIR="${ROOT_DIR}/sql/raw"

# 1. Create the dataset if it doesn't exist
bq --project_id="$PROJECT_ID" mk --dataset --location=US "${PROJECT_ID}:${DATASET}" || true

# 2. Run each DDL file to create tables with an explicit schema
run_ddl () {
  local ddl_file=$1
  echo "Applying DDL: ${ddl_file}..."
  bq query --project_id="$PROJECT_ID" --use_legacy_sql=false < "${DDL_DIR}/${ddl_file}"
}

run_ddl customers_raw.sql
run_ddl products_raw.sql
run_ddl suppliers_raw.sql
run_ddl warehouses_raw.sql
run_ddl orders_raw.sql
run_ddl order_items_raw.sql
run_ddl inventory_daily_raw.sql
run_ddl purchase_orders_raw.sql
run_ddl shipments_raw.sql
run_ddl payments_raw.sql
run_ddl returns_raw.sql
run_ddl promotions_raw.sql

# 3. Load each CSV into its already-created table (no --autodetect,
#    since the schema is already defined by the DDL above)
load_table () {
  local table=$1
  local file=$2
  echo "Loading ${table}..."
  bq --project_id="$PROJECT_ID" load \
    --source_format=CSV \
    --skip_leading_rows=1 \
    --replace \
    "${DATASET}.${table}" \
    "${DATA_DIR}/${file}"
}

load_table customers        customers.csv
load_table products         products.csv
load_table suppliers        suppliers.csv
load_table warehouses       warehouses.csv
load_table orders           orders.csv
load_table order_items      order_items.csv
load_table inventory_daily  inventory_daily.csv
load_table purchase_orders  purchase_orders.csv
load_table shipments        shipments.csv
load_table payments         payments.csv
load_table returns          returns.csv
load_table promotions       promotions.csv

echo "Done. Raw tables are in ${PROJECT_ID}:${DATASET}"
