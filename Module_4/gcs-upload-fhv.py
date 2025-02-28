import requests
import gzip
import io
from google.cloud import storage
from concurrent.futures import ThreadPoolExecutor
import time

# If you authenticated through the GCP SDK, you can comment out these two lines
CREDENTIALS_FILE = "/home/thatlaconic/DEzoomcamp_activities/Module_2/service-account.json"
client = storage.Client.from_service_account_json(CREDENTIALS_FILE)

# Constants
BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-{month}.csv.gz"  # Updated base URL for CSV.GZ
MONTHS = [f"{i:02d}" for i in range(1, 13)]  # Months from 01 to 12
BUCKET_NAME = "dezoom-hw-2"  # Replace with your GCS bucket name

CHUNK_SIZE = 8 * 1024 * 1024  # 8 MB

# Initialize GCS bucket
bucket = client.bucket(BUCKET_NAME)


def download_and_decompress(url):
    """Download a .csv.gz file and decompress it in memory."""
    try:
        print(f"Downloading and decompressing {url}...")
        response = requests.get(url, stream=True)
        response.raise_for_status()  # Raise an exception for HTTP errors

        # Decompress the file in memory
        with gzip.GzipFile(fileobj=io.BytesIO(response.content), mode="rb") as gz_file:
            decompressed_data = gz_file.read()

        print(f"Downloaded and decompressed: {url}")
        return decompressed_data
    except requests.exceptions.HTTPError as e:
        print(f"Failed to download {url}: {e}")
        return None
    except Exception as e:
        print(f"Failed to decompress {url}: {e}")
        return None


def upload_to_gcs(data, blob_name, max_retries=3):
    """Upload decompressed data to GCS."""
    blob = bucket.blob(blob_name)
    blob.chunk_size = CHUNK_SIZE

    for attempt in range(max_retries):
        try:
            print(f"Uploading {blob_name} to GCS (Attempt {attempt + 1})...")
            blob.upload_from_string(data, content_type="text/csv")
            print(f"Uploaded: gs://{BUCKET_NAME}/{blob_name}")
            return
        except Exception as e:
            print(f"Failed to upload {blob_name} to GCS: {e}")
            if attempt < max_retries - 1:
                print(f"Retrying in 5 seconds...")
                time.sleep(5)  # Wait before retrying
            else:
                print(f"Giving up on {blob_name} after {max_retries} attempts.")
                raise  # Re-raise the exception after final attempt


def process_month(month):
    """Process a single month: download, decompress, and upload the file."""
    url = BASE_URL.format(month=month)
    blob_name = f"fhv_tripdata_2019-{month}.csv"  # Upload as .csv

    # Download and decompress the file
    decompressed_data = download_and_decompress(url)
    if decompressed_data is None:
        return  # Skip this file if download or decompression failed

    # Upload the decompressed file to GCS
    try:
        upload_to_gcs(decompressed_data, blob_name)
    except Exception as e:
        print(f"Failed to process {url}: {e}")


if __name__ == "__main__":
    # Process all months in parallel
    with ThreadPoolExecutor(max_workers=4) as executor:
        executor.map(process_month, MONTHS)

    print("All files processed and uploaded.")