variable "project_id" {
  description = "The project ID to host the repository in"
  type        = string
}

variable "region" {
  description = "The region to host the repository in"
  type        = string
}

variable "repository_id" {
  description = "The ID of the repository"
  type        = string
}

variable "description" {
  description = "The description of the repository"
  type        = string
}

variable "format" {
  description = "The format of the repository (e.g., DOCKER)"
  type        = string
} 