output "service_account_email" {
  description = "The email of the service account created for GitHub Actions"
  value       = google_service_account.github_actions.email
}

output "service_account_name" {
  description = "The fully qualified name of the service account"
  value       = google_service_account.github_actions.name
} 