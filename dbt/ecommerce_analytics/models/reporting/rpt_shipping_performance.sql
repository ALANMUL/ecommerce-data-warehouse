-- Supply chain: carrier / warehouse delivery performance.
select
    carrier,
    warehouse_id,
    shipping_mode,
    count(distinct shipment_id) as shipments,
    safe_divide(sum(is_delivered), count(*)) as delivery_rate,
    safe_divide(sum(is_late_delivery), count(*)) as late_delivery_rate,
    avg(delivery_delay_days) as avg_delay_days,
    avg(processing_days) as avg_processing_days,
    avg(shipping_cost) as avg_shipping_cost,
    avg(delivery_attempts) as avg_delivery_attempts
from {{ ref('fact_shipments') }}
group by 1, 2, 3
