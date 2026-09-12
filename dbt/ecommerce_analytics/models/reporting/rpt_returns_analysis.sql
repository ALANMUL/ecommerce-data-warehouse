select
    category,
    brand,
    reason,
    condition,
    count(distinct return_id) as return_count,
    sum(quantity) as units_returned,
    sum(refund_amount) as refund_amount,
    safe_divide(sum(restocked_flag), count(*)) as restock_rate
from {{ ref('fact_returns') }}
group by 1, 2, 3, 4
