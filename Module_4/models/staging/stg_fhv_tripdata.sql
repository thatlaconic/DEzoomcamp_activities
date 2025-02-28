{{
    config(
        materialized='view'
    )
}}

with tripdata as (
    select *, row_number() over(partition by dispatching_base_num, pickup_datetime) as rn
  from {{ source('staging','fhv_tripdata') }}
  where dispatching_base_num is not null 
) 
select 
{{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as uniqeid,
{{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }} as pulocationid,
{{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }} as dolocationid,
cast(pickup_datetime as timestamp) as pickup_datetime,
cast(dropOff_datetime as timestamp) as dropoff_datetime,
{{ dbt.safe_cast("SR_FLAG", api.Column.translate_type("integer")) }} as sr_flag,
cast(dispatching_base_num as string) as dispatching_base_num,
cast(Affiliated_base_number as string) as affiliated_base_num
from tripdata
where rn = 1

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=false) %}

  limit 100

{% endif %} 

