terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# VM Configuration
resource "google_compute_instance" "elk_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.disk_size_gb
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  metadata_startup_script = templatefile("${path.module}/startup-script.tpl", {
    ssh_user               = var.ssh_user
    elasticsearch_username = var.elasticsearch_username
    elasticsearch_password = var.elasticsearch_password
    elasticsearch_memory   = var.elasticsearch_memory
    logstash_memory        = var.logstash_memory
  })

  tags = concat(var.tags, ["elasticsearch"])
}

# Firewall rules
resource "google_compute_firewall" "elk_ports" {
  name    = "${var.vm_name}-ports"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22", "9200", "5601", "5044", "5000", "9600"]
  }

  allow {
    protocol = "udp"
    ports    = ["5000"]
  }

  source_ranges = var.source_ranges
  target_tags   = concat(var.tags, ["elasticsearch"])
}

# Additional firewall rule for GKE cluster access
resource "google_compute_firewall" "allow_gke_to_elasticsearch" {
  name        = "${var.vm_name}-gke-access"
  network     = var.network
  description = "Allow GKE cluster nodes to access Elasticsearch"

  allow {
    protocol = "tcp"
    ports    = ["9200"]
  }

  source_ranges = [var.gke_cluster_node_ip_range]
  target_tags   = ["elasticsearch"]
}