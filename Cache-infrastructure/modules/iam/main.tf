resource "google_service_account" "github_actions" {
  project      = var.project_id
  account_id   = "github-actions-sa"
  display_name = "Service Account for GitHub Actions"
  description  = "Service account used by GitHub Actions for CI/CD"
}

# IAM bindings for Artifact Registry
resource "google_artifact_registry_repository_iam_member" "github_actions_ar" {
  project    = var.project_id
  location   = var.region
  repository = var.artifact_registry_name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.github_actions.email}"
}

# IAM bindings for Cloud Run
resource "google_project_iam_member" "github_actions_run" {
  project = var.project_id
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# IAM bindings for Pub/Sub
resource "google_project_iam_member" "github_actions_pubsub" {
  project = var.project_id
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# IAM bindings for Service Account User
resource "google_project_iam_member" "github_actions_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
} 