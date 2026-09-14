select
    return_id,
    order_id,
    product_id,
    customer_id,
    return_date,
    quantity,
    reason,
    refund_amount,
    condition,
    restocked_flag,
    product_name,
    category,
    brand,
    supplier_id
from {{ ref('int_returns') }}