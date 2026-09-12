with source as (
    select * from {{ source('raw_ecommerce', 'customers') }}
),

renamed as (
    select
        customer_id,
        first_name,
        last_name,
        trim(lower(email)) as email,
        cast(signup_date as date) as signup_date,
        region,
        city,
        state,
        cast(zipcode as string) as zipcode,
        channel,
        cast(acquisition_cost as float64) as acquisition_cost,
        cast(is_active as int64) as is_active,
        cast(churned_date as date) as churned_date
    from source
)

select * from renamed
