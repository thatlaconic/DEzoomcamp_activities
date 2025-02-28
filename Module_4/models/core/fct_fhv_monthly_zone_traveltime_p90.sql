
{{
    config(
        materialized='table'
    )
}}

with cte as (
    select *,
    timestamp_diff(dropOff_datetime, pickup_datetime, second) as trip_duration,
    from {{ ref('dim_fhv_trips') }}
)
    select distinct
    pickup_zone,
    dropoff_zone,
    percentile_cont(trip_duration, 0.90) over(partition by year, month, pickup_locationid, dropoff_locationid) as percentile
    from cte
    where year = 2019 and month = 11 and pickup_zone in ('Newark Airport', 'SoHo', 'Yorkville East')
    order by pickup_zone, percentile desc