resource "google_compute_instance" "bastion" {
  name         = "${var.environment}-bastion"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }

  network_interface {
    subnetwork = var.subnet_name
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Install required tools
    apt-get update
    apt-get install -y kubectl postgresql-client
    # sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
    # Install gcloud CLI
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    apt-get update && apt-get install -y google-cloud-sdk
    # Configure kubectl
    gcloud container clusters get-credentials ${var.gke_cluster_name} --region ${var.region} --project ${var.project_id}
  EOF

  tags = ["bastion"]
}

resource "google_compute_firewall" "bastion_ssh" {
  name    = "${var.environment}-bastion-ssh"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
} 