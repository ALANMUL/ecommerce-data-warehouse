with source as (
    select * from {{ source('raw_ecommerce', 'suppliers') }}
),

renamed as (
    select
        supplier_id,
        supplier_name,
        country,
        currency,
        payment_terms,
        cast(lead_time_mean_days as int64) as lead_time_mean_days,
        cast(lead_time_cv as float64) as lead_time_cv,
        cast(min_order_qty as int64) as min_order_qty,
        cast(contract_start_date as date) as contract_start_date,
        cast(is_active as int64) as is_active
    from source
)

select * from renamed
