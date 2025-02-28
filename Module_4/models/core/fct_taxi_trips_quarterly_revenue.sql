{{
    config(
        materialized='table'
    )
}}


WITH CTE AS (SELECT  
    service_type,
    EXTRACT(YEAR FROM DATE(dropoff_datetime)) AS year,
    EXTRACT(QUARTER FROM DATE(dropoff_datetime)) AS quarter,
    SUM(total_amount) as current_total_per_quarter,
FROM {{ ref('fact_trips') }}
where EXTRACT(YEAR FROM DATE(dropoff_datetime)) IN (2019, 2020) 
GROUP BY service_type, year, quarter),
CTE2 AS (SELECT *, 
LAG(current_total_per_quarter) OVER(partition by service_type order by quarter desc, year) as previous_year_amount
FROM CTE
) 
SELECT CTE2.service_type, CTE2.year, CTE2.quarter, CTE2.current_total_per_quarter, CTE2.previous_year_amount,
 ((CTE2.current_total_per_quarter - CTE2.previous_year_amount)/CTE2.previous_year_amount)*100 as growth_revenue
FROM CTE2
WHERE CTE2.YEAR = 2020
ORDER BY CTE2.service_type, growth_revenue
