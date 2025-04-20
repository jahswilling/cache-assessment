variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-west1"
}

variable "artifact_registry_name" {
  description = "The name of the Artifact Registry repository"
  type        = string
} 