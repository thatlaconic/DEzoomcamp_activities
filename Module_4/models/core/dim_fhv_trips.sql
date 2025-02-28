
{{
    config(
        materialized='table'
    )
}}

with fhv_trip as (
    select *,
    EXTRACT(YEAR FROM DATE(pickup_datetime)) AS year,
    EXTRACT(MONTH FROM DATE(pickup_datetime)) AS month
    from {{ ref('stg_fhv_tripdata') }}
    where dispatching_base_num is not null
),
dim_zones as (
    select *
    from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select 
    pickup_zone.locationid as pickup_locationid,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    pickup_zone.service_zone as pickup_service_zone,
    dropoff_zone.locationid as dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,
    dropoff_zone.service_zone as dropoff_service_zone,
    fhv_trip.dispatching_base_num,
    fhv_trip.pickup_datetime,
    fhv_trip.dropOff_datetime,
    fhv_trip.year,
    fhv_trip.month,
    fhv_trip.SR_FLAG,
    fhv_trip.affiliated_base_num
    from fhv_trip
    inner join dim_zones as pickup_zone on fhv_trip.PUlocationID = pickup_zone.locationid
    inner join dim_zones as dropoff_zone on fhv_trip.DOlocationID = dropoff_zone.locationid 
