# **Workshop "Data Ingestion with dlt": Homework**


## **Dataset & API**

We’ll use **NYC Taxi data** via the same custom API from the workshop:

🔹 **Base API URL:**  
```
https://us-central1-dlthub-analytics.cloudfunctions.net/data_engineering_zoomcamp_api
```
🔹 **Data format:** Paginated JSON (1,000 records per page).  
🔹 **API Pagination:** Stop when an empty page is returned.

## **Question 1: dlt Version**

**Install dlt**:

```bash
pip install dlt
```
**Check** the version:

```bash
dlt --version
```
Provide the **version** you see in the output.
* `1.6.1`

## **Question 2: Define & Run the Pipeline (NYC Taxi API)**

Use dlt to extract all pages of data from the API.

Steps:

1️⃣ Use the `@dlt.resource` decorator to define the API source.

2️⃣ Implement automatic pagination using dlt's built-in REST client.

3️⃣ Load the extracted data into DuckDB for querying.

How many tables were created?

* `4`

## **Question 3: Explore the loaded data**

Inspect the table `ride`: What is the total number of records extracted?

* `10000`

## **Question 4: Trip Duration Analysis**

Calculate the average trip duration in minutes. What is the average trip duration?

* `12.3049`