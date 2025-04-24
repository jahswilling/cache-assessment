output "vm_name" {
  value       = google_compute_instance.elk_vm.name
  description = "Name of the ELK stack VM"
}

output "vm_ip" {
  value       = google_compute_instance.elk_vm.network_interface[0].access_config[0].nat_ip
  description = "Public IP address of the ELK stack VM"
}

output "kibana_url" {
  value       = "http://${google_compute_instance.elk_vm.network_interface[0].access_config[0].nat_ip}:5601"
  description = "URL to access Kibana"
}

output "elasticsearch_url" {
  value       = "http://${google_compute_instance.elk_vm.network_interface[0].access_config[0].nat_ip}:9200"
  description = "URL to access Elasticsearch"
}

output "logstash_url" {
  value       = "http://${google_compute_instance.elk_vm.network_interface[0].access_config[0].nat_ip}:5044"
  description = "URL to access Logstash"
}

output "ssh_command" {
  value       = "gcloud compute ssh ${google_compute_instance.elk_vm.name} --zone=${var.zone}"
  description = "SSH command to connect to the VM"
} 