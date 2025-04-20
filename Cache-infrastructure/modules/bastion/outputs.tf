output "bastion_instance_name" {
  description = "The name of the bastion instance"
  value       = google_compute_instance.bastion.name
}

output "bastion_public_ip" {
  description = "The public IP address of the bastion host"
  value       = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
}

output "bastion_ssh_command" {
  description = "The SSH command to connect to the bastion host"
  value       = "ssh ${var.ssh_user}@${google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip}"
} 