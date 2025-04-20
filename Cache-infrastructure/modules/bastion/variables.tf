variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
}

variable "zone" {
  description = "The zone to deploy the bastion host to"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "gke_cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "ssh_user" {
  description = "The SSH user for the bastion host"
  type        = string
  default     = "bastion"
}

variable "ssh_pub_key_path" {
  description = "Path to the SSH public key file"
  type        = string
} 