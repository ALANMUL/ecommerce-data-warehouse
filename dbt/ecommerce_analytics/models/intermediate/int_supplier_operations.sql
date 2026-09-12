-- Purchase-order grain supplier performance signal.
with po as (
    select * from {{ ref('stg_purchase_orders') }}
),

suppliers as (
    select supplier_id, supplier_name, country, currency, payment_terms,
           lead_time_mean_days, lead_time_cv, min_order_qty, is_active
    from {{ ref('stg_suppliers') }}
),

final as (
    select
        po.po_id,
        po.supplier_id,
        s.supplier_name,
        s.country,
        s.currency,
        s.payment_terms,
        po.product_id,
        po.warehouse_id,
        po.order_date,
        po.expected_delivery_date,
        po.received_date,
        po.qty_ordered,
        po.qty_received,
        po.qty_shortfall,
        po.unit_cost,
        po.total_value,
        po.actual_lead_days,
        s.lead_time_mean_days as contracted_lead_time_days,
        po.days_late,
        case when po.days_late > 0 then 1 else 0 end as is_late,
        case when po.qty_shortfall > 0 then 1 else 0 end as is_short_shipped,
        po.status
    from po
    left join suppliers s on po.supplier_id = s.supplier_id
)

select * from final
