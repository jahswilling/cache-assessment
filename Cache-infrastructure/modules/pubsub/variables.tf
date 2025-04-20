variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "topic_name" {
  description = "Name of the Pub/Sub topic"
  type        = string
}

variable "subscription_name" {
  description = "Name of the Pub/Sub subscription"
  type        = string
}

variable "message_retention_duration" {
  description = "How long to retain unacknowledged messages in the subscription"
  type        = string
  default     = "604800s" # 7 days
}

variable "ack_deadline_seconds" {
  description = "Number of seconds after which a message is considered not acknowledged"
  type        = number
  default     = 600 # 10 minutes
}

variable "enable_message_ordering" {
  description = "Whether to enable message ordering"
  type        = bool
  default     = false
}

variable "dead_letter_topic" {
  description = "The dead letter topic to send failed messages to"
  type        = string
  default     = null
}

variable "max_delivery_attempts" {
  description = "Maximum number of delivery attempts for dead letter topics"
  type        = number
  default     = 5
} 