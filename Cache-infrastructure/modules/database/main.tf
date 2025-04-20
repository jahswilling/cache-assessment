resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database" "database" {
  name            = "${var.environment}-database"
  instance        = google_sql_database_instance.postgres.name
  deletion_policy = "ABANDON"
}

resource "google_sql_user" "database_user" {
  name     = var.database_root_username
  instance = google_sql_database_instance.postgres.name
  password = var.database_root_password
}

resource "google_sql_database_instance" "postgres" {
  name             = "${var.environment}-postgres-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_15"
  deletion_protection = false
  depends_on = [var.vpc_dependency, var.gcp_services_dependency]

  settings {
    tier      = var.tier
    disk_size = 100
    database_flags {
      name  = "log_connections"
      value = "on"
    }
    database_flags {
      name  = "max_connections"
      value = "5000"
    }
    insights_config {
      query_insights_enabled  = true
      query_plans_per_minute  = 5
      query_string_length     = 1024
      record_application_tags = false
      record_client_address   = false
    }

    backup_configuration {
      enabled                        = true
      start_time                     = "23:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
      }
    }
    maintenance_window {
      day          = 1
      hour         = 4
      update_track = "stable"
    }
    ip_configuration {
      ipv4_enabled = true
      dynamic "authorized_networks" {
        for_each = var.allowed_cidr
        content {
          name  = "network-${authorized_networks.key}"
          value = authorized_networks.value
        }
      }
    }
  }
}

resource "google_sql_database" "databases" {
  for_each        = { for db in var.db_list : db => db }
  name            = each.value
  instance        = google_sql_database_instance.postgres.name
  deletion_policy = "ABANDON"
} 