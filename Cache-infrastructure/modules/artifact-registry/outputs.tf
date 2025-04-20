output "repository_name" {
  description = "The name of the repository"
  value       = google_artifact_registry_repository.repository.name
}

output "repository_id" {
  description = "The ID of the repository"
  value       = google_artifact_registry_repository.repository.repository_id
}

output "repository_url" {
  description = "The URL of the repository"
  value       = google_artifact_registry_repository.repository.name
} 