variable "project_id" {
  description = "The project ID to host the network in"
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

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
}

variable "region" {
  description = "The region to host the network in"
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