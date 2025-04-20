output "database_instance_name" {
  description = "Name of the database instance"
  value       = google_sql_database_instance.postgres.name
}

output "database_instance_connection_name" {
  description = "Connection name of the database instance"
  value       = google_sql_database_instance.postgres.connection_name
}

output "database_instance_ip_address" {
  description = "IP address of the database instance"
  value       = google_sql_database_instance.postgres.private_ip_address
}

output "database_name" {
  description = "Name of the created database"
  value       = google_sql_database.database.name
}

output "database_user_name" {
  description = "Name of the database user"
  value       = google_sql_user.database_user.name
} 