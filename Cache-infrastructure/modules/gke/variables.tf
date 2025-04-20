variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "gke_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}

variable "gke_node_zones" {
  description = "The zones to host the cluster in"
  type        = list(string)
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "gke_subnet" {
  description = "The name of the subnet"
  type        = string
}

variable "pods_range_name" {
  description = "The name of the secondary subnet ip range to use for pods"
  type        = string
}

variable "svc_range_name" {
  description = "The name of the secondary subnet range to use for services"
  type        = string
}

variable "pods_cidr" {
  description = "The CIDR range for pods"
  type        = string
}

variable "svc_cidr" {
  description = "The CIDR range for services"
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
  description = "The Kubernetes version to use"
  type        = string
}

variable "node_pools" {
  description = "List of node pools to create"
  type = list(object({
    name               = string
    machine_type       = string
    node_locations     = string
    min_count          = number
    max_count          = number
    disk_size_gb       = number
  }))
}

variable "node_pools_oauth_scopes" {
  description = "The OAuth scopes for the node pools"
  type        = map(list(string))
}

variable "node_pools_labels" {
  description = "The labels to apply to the node pools"
  type        = map(map(string))
}

variable "node_pools_tags" {
  description = "The tags to apply to the node pools"
  type        = map(list(string))
}

variable "node_pools_taints" {
  description = "The taints to apply to the node pools"
  type        = map(list(object({
    key    = string
    value  = string
    effect = string
  })))
}

variable "gke_master_ipv4_cidr_block" {
  description = "The CIDR block for the GKE master"
  type        = string
} 