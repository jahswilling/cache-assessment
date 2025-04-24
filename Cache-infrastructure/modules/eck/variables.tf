variable "elasticsearch_cluster_name" {
  description = "Name of the Elasticsearch cluster"
  type        = string
  default     = "elasticsearch"
}

variable "namespace" {
  description = "Namespace where the Elasticsearch cluster will be deployed"
  type        = string
  default     = "elasticsearch"
}

variable "elasticsearch_version" {
  description = "Version of Elasticsearch to deploy"
  type        = string
  default     = "8.11.0"
}

variable "node_count" {
  description = "Number of Elasticsearch nodes to deploy"
  type        = number
  default     = 3
}

variable "memory_request" {
  description = "Memory request for Elasticsearch pods"
  type        = string
  default     = "4Gi"
}

variable "cpu_request" {
  description = "CPU request for Elasticsearch pods"
  type        = string
  default     = "2"
}

variable "memory_limit" {
  description = "Memory limit for Elasticsearch pods"
  type        = string
  default     = "8Gi"
}

variable "cpu_limit" {
  description = "CPU limit for Elasticsearch pods"
  type        = string
  default     = "4"
} 