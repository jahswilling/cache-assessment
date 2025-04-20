# Create Pub/Sub topic
resource "google_pubsub_topic" "topic" {
  name    = "${var.environment}-${var.topic_name}"
  project = var.project_id

  message_retention_duration = var.message_retention_duration
}

# Create Pub/Sub subscription
resource "google_pubsub_subscription" "subscription" {
  name    = "${var.environment}-${var.subscription_name}"
  topic   = google_pubsub_topic.topic.name
  project = var.project_id

  ack_deadline_seconds = var.ack_deadline_seconds
  message_retention_duration = var.message_retention_duration
} 