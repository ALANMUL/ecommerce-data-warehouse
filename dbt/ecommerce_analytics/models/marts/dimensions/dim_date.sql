{{
  config(materialized='table')
}}

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2022-01-01' as date)",
        end_date="cast('2027-01-01' as date)"
    ) }}
),

final as (
    select
        cast(date_day as date) as date_day,
        extract(year from date_day) as year,
        extract(quarter from date_day) as quarter,
        extract(month from date_day) as month,
        format_date('%B', date_day) as month_name,
        extract(week from date_day) as week_of_year,
        extract(dayofweek from date_day) as day_of_week,
        format_date('%A', date_day) as day_name,
        case when extract(dayofweek from date_day) in (1, 7) then true else false end as is_weekend,
        date_trunc(date_day, month) as month_start_date,
        date_trunc(date_day, quarter) as quarter_start_date,
        date_trunc(date_day, year) as year_start_date
    from date_spine
)

select * from final
