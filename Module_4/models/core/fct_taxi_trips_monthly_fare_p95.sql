
{{
    config(
        materialized='view'
    )
}}

with cte as (
    select 
    *,
    EXTRACT(YEAR FROM DATE(dropoff_datetime)) AS year,
    EXTRACT(MONTH FROM DATE(dropoff_datetime)) AS month,
    from {{ ref('fact_trips') }}
    where fare_amount > 0 and trip_distance > 0 and payment_type_description in ('Cash', 'Credit card')
)
select distinct
    service_type,
    percentile_cont(fare_amount, 0.97) over(partition by service_type, year, month) as p97,
    percentile_cont(fare_amount, 0.95) over(partition by service_type, year, month) as p95,
    percentile_cont(fare_amount, 0.90) over(partition by service_type, year, month) as p90
from cte
where month = 4 and year = 2020
