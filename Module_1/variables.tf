variable "credentials" {
  description = "My Credentials"
  default     = "/home/thatlaconic/DEzoomcamp_activities/Module_1/mycreds.json"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "region" {
  description = "Project region"
  default     = "us-central1"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "example_dataset"
}

variable "Project" {
  description = "My Project Name"
  default     = "homeworks-448912"
}

variable "gcp_storage_bucket" {
  description = "My storage bucket name"
  default     = "terraform-hw-bucket"
}

variable "gcp_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

