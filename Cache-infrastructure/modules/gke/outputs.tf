output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.name
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = module.gke.endpoint
}

output "cluster_ca_certificate" {
  description = "The CA certificate of the GKE cluster"
  value       = module.gke.ca_certificate
}

output "cluster_location" {
  description = "The location of the GKE cluster"
  value       = module.gke.location
}

output "cluster_network_name" {
  description = "The network name of the GKE cluster"
  value       = var.network_name
}

output "cluster_subnetwork_name" {
  description = "The subnetwork name of the GKE cluster"
  value       = var.gke_subnet
}

output "cluster_master_version" {
  description = "The master version of the GKE cluster"
  value       = module.gke.master_version
}

output "cluster_region" {
  description = "The region of the GKE cluster"
  value       = var.region
}

output "cluster_zones" {
  description = "The zones of the GKE cluster"
  value       = var.gke_node_zones
}

output "cluster_node_ip_range" {
  description = "The IP range of the GKE cluster nodes"
  value       = var.pods_cidr
} 