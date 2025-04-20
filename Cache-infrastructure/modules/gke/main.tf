resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                 = "30.0.0"
  project_id              = var.project_id
  name                    = var.gke_name
  region                  = var.region
  zones                   = var.gke_node_zones
  network                 = var.network_name
  subnetwork              = var.gke_subnet
  ip_range_pods          = var.pods_range_name
  ip_range_services      = var.svc_range_name
  cluster_autoscaling     = var.cluster_autoscaling
  enable_private_endpoint = true
  enable_private_nodes    = true
  master_ipv4_cidr_block = var.gke_master_ipv4_cidr_block
  master_authorized_networks = [
    {
      cidr_block   = "10.0.0.0/20"
      display_name = "GKE Master CIDR"
    }
  ]

  cluster_resource_labels = var.cluster_resource_labels
  create_service_account  = true
  deletion_protection    = false
  enable_cost_allocation = true
  gce_pd_csi_driver      = true
  grant_registry_access  = true
  horizontal_pod_autoscaling = true
  http_load_balancing    = true
  remove_default_node_pool = true
  kubernetes_version     = var.kubernetes_version

  network_policy       = true

  node_pools = var.node_pools
  node_pools_oauth_scopes = var.node_pools_oauth_scopes
  node_pools_labels      = var.node_pools_labels
  node_pools_tags        = var.node_pools_tags
}

resource "google_compute_firewall" "allow_pods_and_services" {
  name        = "allow-gke-communication"
  project     = var.project_id
  network     = var.network_name
  direction   = "INGRESS"
  target_tags = [module.gke.name]

  source_ranges = ["10.0.0.0/20", var.pods_cidr, var.svc_cidr]

  allow {
    protocol = "tcp"
    ports    = ["8443", "8080"]
  }

  depends_on = [module.gke]
} 