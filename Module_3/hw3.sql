-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `homeworks-448912.dezoom_hw_3.external_yellow_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://dezoom-hw-3/yellow_tripdata_2024-*.parquet']
);

-- Check yellow trip data
SELECT COUNT(1) FROM homeworks-448912.dezoom_hw_3.external_yellow_tripdata;

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE homeworks-448912.dezoom_hw_3.yellow_tripdata_non_partitioned AS
SELECT * FROM homeworks-448912.dezoom_hw_3.external_yellow_tripdata;

-- scanning 0MB of data
SELECT COUNT(DISTINCT PULocationID) FROM homeworks-448912.dezoom_hw_3.external_yellow_tripdata;

--scanning 155.12MB of data
SELECT COUNT(DISTINCT PULocationID) FROM homeworks-448912.dezoom_hw_3.yellow_tripdata_non_partitioned;

--scanning 155.12MB of data
SELECT PULocationID FROM homeworks-448912.dezoom_hw_3.yellow_tripdata_non_partitioned;

--scanning 310.24MB of data
SELECT PULocationID, DOLocationID FROM homeworks-448912.dezoom_hw_3.yellow_tripdata_non_partitioned;

--
SELECT COUNT(fare_amount) FROM homeworks-448912.dezoom_hw_3.external_yellow_tripdata
WHERE fare_amount = 0;

--
SELECT COUNT(DISTINCT VendorID), COUNT(DISTINCT tpep_dropoff_datetime) 
FROM homeworks-448912.dezoom_hw_3.external_yellow_tripdata;

--
CREATE OR REPLACE TABLE homeworks-448912.dezoom_hw_3.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM homeworks-448912.dezoom_hw_3.external_yellow_tripdata;

-- 28.84MB of data
SELECT DISTINCT VendorID 
FROM homeworks-448912.dezoom_hw_3.yellow_tripdata_partitioned_clustered
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' and '2024-03-16';

-- 310MB of data
SELECT DISTINCT VendorID 
FROM homeworks-448912.dezoom_hw_3.yellow_tripdata_non_partitioned
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' and '2024-03-16';

-- 0B
SELECT COUNT(*) 
FROM homeworks-448912.dezoom_hw_3.yellow_tripdata_non_partitioned;