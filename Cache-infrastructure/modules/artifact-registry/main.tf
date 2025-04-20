resource "google_artifact_registry_repository" "repository" {
  location      = var.region
  repository_id = var.repository_id
  description   = var.description
  format        = var.format
  project       = var.project_id
} 