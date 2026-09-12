with source as (
    select * from {{ source('raw_ecommerce', 'promotions') }}
),

renamed as (
    select
        promo_id,
        promo_name,
        cast(start_date as date) as start_date,
        cast(end_date as date) as end_date,
        cast(discount_pct as float64) as discount_pct
    from source
)

select * from renamed
