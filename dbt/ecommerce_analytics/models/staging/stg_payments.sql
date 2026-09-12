with source as (
    select * from {{ source('raw_ecommerce', 'payments') }}
),

renamed as (
    select
        payment_id,
        order_id,
        payment_method,
        cast(amount as float64) as amount,
        status,
        cast(transaction_date as date) as transaction_date,
        nullif(failure_reason, '') as failure_reason,
        cast(refund_amount as float64) as refund_amount
    from source
)

select * from renamed
