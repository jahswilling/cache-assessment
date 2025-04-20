# Network outputs
output "network_name" {
  description = "The name of the VPC network"
  value       = module.network.network_name
}

output "network_self_link" {
  description = "The self link of the VPC network"
  value       = module.network.network_self_link
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = module.network.subnet_name
}

# GKE outputs
output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = module.gke.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "The CA certificate of the GKE cluster"
  value       = module.gke.cluster_ca_certificate
}

# Database outputs
output "database_instance_name" {
  description = "The name of the database instance"
  value       = module.database.database_instance_name
}

output "database_instance_connection_name" {
  description = "The connection name of the database instance"
  value       = module.database.database_instance_connection_name
}

# Artifact Registry outputs
output "repository_name" {
  description = "The name of the Artifact Registry repository"
  value       = module.artifact_registry.repository_name
}

output "repository_url" {
  description = "The URL of the Artifact Registry repository"
  value       = module.artifact_registry.repository_url
}

# Bastion outputs
output "bastion_instance_name" {
  description = "The name of the bastion instance"
  value       = module.bastion.bastion_instance_name
}

output "bastion_public_ip" {
  description = "The public IP address of the bastion host"
  value       = module.bastion.bastion_public_ip
}

output "bastion_ssh_command" {
  description = "The SSH command to connect to the bastion host"
  value       = module.bastion.bastion_ssh_command
} 