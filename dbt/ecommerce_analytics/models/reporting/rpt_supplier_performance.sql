-- Supply chain: supplier scorecard (lead time reliability, fill rate, spend).
select
    supplier_id,
    supplier_name,
    country,
    payment_terms,
    count(distinct po_id) as purchase_orders,
    sum(qty_ordered) as qty_ordered,
    sum(qty_received) as qty_received,
    safe_divide(sum(qty_received), nullif(sum(qty_ordered), 0)) as fill_rate,
    sum(total_value) as total_spend,
    avg(actual_lead_days) as avg_actual_lead_days,
    avg(contracted_lead_time_days) as avg_contracted_lead_days,
    safe_divide(sum(is_late), count(*)) as pct_late_orders,
    safe_divide(sum(is_short_shipped), count(*)) as pct_short_shipped
from {{ ref('fact_purchase_orders') }}
group by 1, 2, 3, 4
