variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "elk-stack"
}

variable "machine_type" {
  description = "Machine type for the VM"
  type        = string
  default     = "e2-medium"
}

variable "zone" {
  description = "Zone for the VM"
  type        = string
}

variable "disk_size_gb" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 50
}

variable "network" {
  description = "Network for the VM"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Subnetwork for the VM"
  type        = string
}

variable "ssh_user" {
  description = "SSH user for the VM"
  type        = string
}

variable "ssh_pub_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "elasticsearch_username" {
  description = "Username for Elasticsearch"
  type        = string
  default     = "elastic"
}

variable "elasticsearch_password" {
  description = "Password for Elasticsearch"
  type        = string
  sensitive   = true
}

variable "elasticsearch_memory" {
  description = "Memory allocation for Elasticsearch (e.g., '1g')"
  type        = string
  default     = "1g"
}

variable "logstash_memory" {
  description = "Memory allocation for Logstash (e.g., '512m')"
  type        = string
  default     = "512m"
}

variable "tags" {
  description = "Network tags for the VM"
  type        = list(string)
  default     = ["elk"]
}

variable "source_ranges" {
  description = "Source IP ranges for firewall rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Consider restricting this for production
}

variable "gke_cluster_node_ip_range" {
  description = "The IP range of the GKE cluster nodes that need access to Elasticsearch"
  type        = string
}