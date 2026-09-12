select
    payment_id,
    order_id,
    payment_method,
    amount,
    status,
    transaction_date,
    failure_reason,
    refund_amount
from {{ ref('stg_payments') }}
