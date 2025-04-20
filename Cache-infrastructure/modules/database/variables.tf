variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "database_root_username" {
  description = "Root username for the database"
  type        = string
}

variable "database_root_password" {
  description = "Root password for the database"
  type        = string
  sensitive   = true
}

variable "tier" {
  description = "Database instance tier"
  type        = string
}

variable "allowed_cidr" {
  description = "Map of CIDR blocks allowed to access the database"
  type        = map(string)
}

variable "db_list" {
  description = "List of databases to create"
  type        = list(string)
}

variable "vpc_dependency" {
  description = "Dependency on VPC module"
  type        = any
}

variable "gcp_services_dependency" {
  description = "Dependency on GCP services"
  type        = any
} 