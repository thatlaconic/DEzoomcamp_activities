import os
import sys
import requests

# Exit on error
sys.tracebacklimit = 0  # Disable traceback for cleaner error messages

# Parse command-line arguments
if len(sys.argv) != 3:
    print("Usage: python script.py <TAXI_TYPE> <YEAR>")
    sys.exit(1)

TAXI_TYPE = sys.argv[1]  # e.g., "yellow"
YEAR = sys.argv[2]       # e.g., 2020

URL_PREFIX = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

for month in range(1, 13):
    # Format month to two digits (e.g., 01, 02, ..., 12)
    fmonth = f"{month:02d}"

    # Construct the URL
    url = f"{URL_PREFIX}/{TAXI_TYPE}/{TAXI_TYPE}_tripdata_{YEAR}-{fmonth}.csv.gz"

    # Define local file path
    local_prefix = os.path.join("data", "raw", TAXI_TYPE, YEAR, fmonth)
    local_file = f"{TAXI_TYPE}_tripdata_{YEAR}_{fmonth}.csv.gz"
    local_path = os.path.join(local_prefix, local_file)

     
   # Check if the file already exists
    if os.path.exists(local_path):
        print(f"File already exists: {local_path}. Skipping download.")
        continue  # Skip to the next iteration


    # Create directory if it doesn't exist
    os.makedirs(local_prefix, exist_ok=True)

    # Download the file
    print(f"Downloading {url} to {local_path}")
    response = requests.get(url)
    if response.status_code == 200:
        with open(local_path, "wb") as f:
            f.write(response.content)
    else:
        print(f"Failed to download {url}. HTTP Status Code: {response.status_code}")