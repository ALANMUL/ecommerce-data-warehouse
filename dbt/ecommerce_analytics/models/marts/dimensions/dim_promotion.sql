select
    promo_id,
    promo_name,
    start_date,
    end_date,
    discount_pct,
    date_diff(end_date, start_date, day) + 1 as promo_duration_days
from {{ ref('stg_promotions') }}
