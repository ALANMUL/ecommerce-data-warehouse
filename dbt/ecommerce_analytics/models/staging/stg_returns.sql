with source as (
    select * from {{ source('raw_ecommerce', 'returns') }}
),

renamed as (
    select
        return_id,
        order_id,
        product_id,
        customer_id,
        cast(return_date as date) as return_date,
        cast(quantity as int64) as quantity,
        reason,
        cast(refund_amount as float64) as refund_amount,
        condition,
        cast(restocked_flag as int64) as restocked_flag
    from source
)

select * from renamed
