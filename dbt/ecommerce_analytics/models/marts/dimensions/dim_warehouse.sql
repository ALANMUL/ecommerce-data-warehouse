select
    warehouse_id,
    warehouse_name,
    city,
    state,
    case
        when state in ('CA', 'OR', 'WA', 'NV', 'AZ', 'UT', 'CO', 'ID', 'MT', 'WY', 'NM') then 'West'
        when state in ('NY', 'NJ', 'PA', 'MA', 'CT', 'RI', 'VT', 'NH', 'ME', 'MD', 'DE', 'VA', 'WV') then 'Northeast'
        when state in ('TX', 'FL', 'GA', 'NC', 'SC', 'TN', 'AL', 'MS', 'LA', 'AR', 'KY', 'OK') then 'South'
        when state in ('IL', 'OH', 'MI', 'IN', 'WI', 'MN', 'IA', 'MO', 'KS', 'NE', 'ND', 'SD') then 'Midwest'
        else 'Other'
    end as region,
    warehouse_type,
    capacity_units
from {{ ref('stg_warehouses') }}