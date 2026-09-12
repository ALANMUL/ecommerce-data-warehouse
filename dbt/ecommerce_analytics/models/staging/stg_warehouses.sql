with source as (
    select * from {{ source('raw_ecommerce', 'warehouses') }}
),

renamed as (
    select
        warehouse_id,
        warehouse_name,
        city,
        state,
        warehouse_type,
        cast(capacity_units as int64) as capacity_units
    from source
)

select * from renamed
