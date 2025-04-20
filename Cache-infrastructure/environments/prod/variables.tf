# Common variables
variable "project" {
  description = "The host project ID"
  type        = string
}

variable "environment" {
  description = "Name of the environment"
  type        = string
}

variable "region" {
  description = "The region to deploy resources in"
  type        = string
}

# Network variables
variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
}

variable "pods_range_name" {
  description = "The name of the secondary subnet ip range to use for pods"
  type        = string
}

variable "pods_cidr" {
  description = "The CIDR range for pods"
  type        = string
}

variable "svc_range_name" {
  description = "The name of the secondary subnet range to use for services"
  type        = string
}

variable "svc_cidr" {
  description = "The CIDR range for services"
  type        = string
}

variable "private_ip_range_name" {
  description = "The name of the private IP range for VPC service networking"
  type        = string
}

# GKE variables
variable "gke_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "gke_node_zones" {
  description = "The zones to host the cluster in"
  type        = list(string)
}

variable "gke_master_ipv4_cidr_block" {
  description = "GKE cluster master IPv4 CIDR block"
  type        = string
}

variable "cluster_autoscaling" {
  description = "Cluster autoscaling configuration"
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
    gpu_resources       = list(object({
      resource_type = string
      minimum      = number
      maximum      = number
    }))
    auto_repair         = bool
    auto_upgrade        = bool
  })
}

variable "cluster_resource_labels" {
  description = "The labels to apply to the cluster"
  type        = map(string)
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters"
  type        = string
}

variable "node_pools" {
  description = "List of node pool configurations"
  type        = list(any)
}

variable "node_pools_oauth_scopes" {
  description = "The OAuth scopes for node pools"
  type        = map(list(string))
}

variable "node_pools_labels" {
  description = "The labels to apply to node pools"
  type        = map(map(string))
}

variable "node_pools_tags" {
  description = "The tags to apply to node pools"
  type        = map(list(string))
}

variable "node_pools_taints" {
  description = "The taints to apply to node pools"
  type        = map(list(map(string)))
}

# Database variables
variable "database_root_username" {
  description = "The username for the database"
  type        = string
}

variable "database_root_password" {
  description = "The password for the database user"
  type        = string
  sensitive   = true
}

variable "tier" {
  description = "The machine tier for the database instance"
  type        = string
}

variable "allowed_cidr" {
  description = "Map of CIDR blocks allowed to access the database"
  type        = map(string)
}

variable "db_list" {
  description = "The list of databases to create"
  type        = list(string)
}

# Artifact Registry variables
variable "repository_id" {
  description = "The ID of the repository"
  type        = string
}

variable "repository_description" {
  description = "The description of the repository"
  type        = string
}

variable "repository_format" {
  description = "The format of the repository (e.g., DOCKER)"
  type        = string
} 