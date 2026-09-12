-- RFM segmentation: Recency, Frequency, Monetary scoring (1-5) per customer,
-- as of the most recent order date in the dataset.
with orders as (
    select
        customer_id,
        order_id,
        order_date,
        order_total
    from {{ ref('fact_orders') }}
    where order_status not in ('CANCELLED')
),

max_date as (
    select max(order_date) as snapshot_date from orders
),

customer_agg as (
    select
        o.customer_id,
        date_diff((select snapshot_date from max_date), max(o.order_date), day) as recency_days,
        count(distinct o.order_id) as frequency,
        sum(o.order_total) as monetary
    from orders o
    group by o.customer_id
),

scored as (
    select
        *,
        -- lower recency_days = better = higher score, so invert the ntile
        6 - ntile(5) over (order by recency_days) as recency_score,
        ntile(5) over (order by frequency) as frequency_score,
        ntile(5) over (order by monetary) as monetary_score
    from customer_agg
),

segmented as (
    select
        *,
        recency_score + frequency_score + monetary_score as rfm_score,
        cast(recency_score as string) || cast(frequency_score as string) || cast(monetary_score as string) as rfm_cell,
        case
            when recency_score >= 4 and frequency_score >= 4 and monetary_score >= 4 then 'Champions'
            when recency_score >= 3 and frequency_score >= 3 then 'Loyal Customers'
            when recency_score >= 4 and frequency_score <= 2 then 'New Customers'
            when recency_score >= 3 and frequency_score <= 2 then 'Promising'
            when recency_score <= 2 and frequency_score >= 4 then 'At Risk'
            when recency_score <= 2 and monetary_score >= 4 then 'Cant Lose Them'
            when recency_score <= 2 and frequency_score <= 2 and monetary_score <= 2 then 'Hibernating'
            else 'Need Attention'
        end as rfm_segment
    from scored
)

select
    s.customer_id,
    c.region,
    c.channel,
    c.signup_date,
    s.recency_days,
    s.frequency,
    s.monetary,
    s.recency_score,
    s.frequency_score,
    s.monetary_score,
    s.rfm_score,
    s.rfm_cell,
    s.rfm_segment
from segmented s
left join {{ ref('dim_customer') }} c on s.customer_id = c.customer_id
