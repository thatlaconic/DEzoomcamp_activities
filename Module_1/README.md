# Module 1 Homework: Docker & SQL

## Question 1. Understanding docker first run 

Run docker with the `python:3.12.8` image in an interactive mode, use the entrypoint `bash`.

```bash
# Pull library/python
$ docker pull python:3.12.8

# After pulling
$ docker run -it --entrypoint bash python:3.12.8`

#Inside container
root@08d0bbaa2a9b:/#
pip --version
```
What's the version of `pip` in the image?

- 24.3.1


## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that **pgadmin** should use to connect to the postgres database?

- db:5432

If there are more than one answers, select only one of them

##  Prepare Postgres

Run Postgres and load data as shown in the videos
We'll use the green taxi trips from October 2019:

```bash
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
```

You will also need the dataset with zones:

```bash
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```

Download this data and put it into Postgres.

You can use the code from the course. It's up to you whether
you want to use Jupyter or a python script.

## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, **respectively**, happened:
1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles 

```sql
SELECT SUM(CASE WHEN trip_distance <= 1 THEN 1 ELSE 0 END) AS number1,
	SUM(CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 ELSE 0 END) AS number2,
	SUM(CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 ELSE 0 END) AS number3,
	SUM(CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 ELSE 0 END) AS number4,
	SUM(CASE WHEN trip_distance > 10 THEN 1 ELSE 0 END) AS number5
FROM green_trips
WHERE lpep_dropoff_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01'
;
```

- 104,802;  198,924;  109,603;  27,678;  35,189


## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance?
Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance. 
```sql
SELECT lpep_pickup_datetime::DATE AS Date, SUM(trip_distance) AS longest_distance
FROM green_trips
GROUP BY Date, trip_distance
ORDER BY trip_distance DESC
LIMIT 1;
```

- 2019-10-31


## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in
`total_amount` (across all trips) for 2019-10-18?

Consider only `lpep_pickup_datetime` when filtering by date.

```sql
SELECT "Zone", SUM(total_amount)::NUMERIC(10,2) AS total_amount
FROM green_trips gt
JOIN taxi_zone tx ON gt."PULocationID" = tx."LocationID"
WHERE lpep_pickup_datetime::DATE= '2019-10-18' 
GROUP BY "Zone"
ORDER BY total_amount DESC
LIMIT 3;
```
 
- East Harlem North, East Harlem South, Morningside Heights



## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone
named "East Harlem North" which was the drop off zone that had
the largest tip?

Note: it's `tip` , not `trip`

We need the name of the zone, not the ID.

```sql
WITH CTE AS(SELECT "PULocationID", 
					"DOLocationID", "Zone" AS pu_zone, 
					tip_amount,
					TO_CHAR(lpep_pickup_datetime, 'YYYY-MM-DD') AS date_trip
		FROM green_trips gt
		JOIN taxi_zone tx ON gt."PULocationID" = tx."LocationID"
		WHERE TO_CHAR(lpep_pickup_datetime, 'YYYY-MM-DD') LIKE '2019-10-%' and "Zone" = 'East Harlem North')
SELECT "Zone" AS do_zone
FROM CTE
JOIN taxi_zone tx ON CTE."DOLocationID" = tx."LocationID"
GROUP BY do_zone
ORDER BY MAX(tip_amount) DESC
LIMIT 1;
```

- JFK Airport



## Terraform

## Question 7. Terraform Workflow

Which of the following sequences, **respectively**, describes the workflow for: 
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:

- terraform init, terraform apply -auto-approve, terraform destroy

