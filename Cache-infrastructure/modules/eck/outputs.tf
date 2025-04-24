output "elasticsearch_cluster_name" {
  description = "Name of the deployed Elasticsearch cluster"
  value       = var.elasticsearch_cluster_name
}

output "elasticsearch_namespace" {
  description = "Namespace where Elasticsearch is deployed"
  value       = var.namespace
}

output "elasticsearch_version" {
  description = "Version of Elasticsearch deployed"
  value       = var.elasticsearch_version
} 