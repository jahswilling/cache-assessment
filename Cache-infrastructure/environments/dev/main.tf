# Enable required APIs
resource "google_project_service" "gcp_services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com",
    "servicenetworking.googleapis.com",
    "pubsub.googleapis.com"
  ])
  project = var.project
  service = each.key

  disable_dependent_services = true
  disable_on_destroy        = false
}

# Create VPC Network
module "network" {
  source = "../../modules/network"

  project_id      = var.project
  network_name    = var.network_name
  subnet_name     = var.subnet_name
  subnet_cidr     = var.subnet_cidr
  region          = var.region
  pods_range_name = var.pods_range_name
  pods_cidr       = var.pods_cidr
  svc_range_name  = var.svc_range_name
  svc_cidr        = var.svc_cidr

  depends_on = [
    google_project_service.gcp_services
  ]
}

# Create GKE Cluster
module "gke" {
  source = "../../modules/gke"

  project_id                    = var.project
  gke_name                     = var.gke_name
  region                       = var.region
  gke_node_zones              = var.gke_node_zones
  network_name                = module.network.network_name
  gke_subnet                  = module.network.subnet_name
  pods_range_name             = var.pods_range_name
  pods_cidr                   = var.pods_cidr
  svc_range_name              = var.svc_range_name
  svc_cidr                    = var.svc_cidr
  cluster_autoscaling         = {
    enabled             = var.cluster_autoscaling.enabled
    autoscaling_profile = var.cluster_autoscaling.autoscaling_profile
    min_cpu_cores       = var.cluster_autoscaling.min_cpu_cores
    max_cpu_cores       = var.cluster_autoscaling.max_cpu_cores
    min_memory_gb       = var.cluster_autoscaling.min_memory_gb
    max_memory_gb       = var.cluster_autoscaling.max_memory_gb
    gpu_resources       = []  # Empty list as we don't need GPUs
    auto_repair         = var.cluster_autoscaling.auto_repair
    auto_upgrade        = var.cluster_autoscaling.auto_upgrade
  }
  cluster_resource_labels     = var.cluster_resource_labels
  kubernetes_version          = var.kubernetes_version
  node_pools                  = var.node_pools
  node_pools_oauth_scopes     = var.node_pools_oauth_scopes
  node_pools_labels           = var.node_pools_labels
  node_pools_tags             = var.node_pools_tags
  node_pools_taints           = var.node_pools_taints
  gke_master_ipv4_cidr_block = var.gke_master_ipv4_cidr_block
}

# Create Cloud SQL Database
module "database" {
  source = "../../modules/database"

  environment                        = var.environment
  database_root_username            = var.database_root_username
  database_root_password            = var.database_root_password
  tier                             = var.tier
  allowed_cidr                     = var.allowed_cidr
  db_list                          = var.db_list
  vpc_dependency                   = module.network
  gcp_services_dependency          = google_project_service.gcp_services
}

# Create Artifact Registry
module "artifact_registry" {
  source = "../../modules/artifact-registry"

  project_id     = var.project
  region         = var.region
  repository_id  = var.repository_id
  description    = var.repository_description
  format         = var.repository_format
}

# Create Bastion Host
module "bastion" {
  source = "../../modules/bastion"

  environment      = var.environment
  project_id      = var.project
  region          = var.region
  zone            = "${var.region}-a"  # Using the first zone in the region
  network_name    = module.network.network_name
  subnet_name     = module.network.subnet_name
  gke_cluster_name = var.gke_name
  ssh_user        = "bastion"
  ssh_pub_key_path = "~/.ssh/cache-ssh-key.pub"  # Update this path to your SSH public key
}

# Create Pub/Sub topic and subscription
module "pubsub" {
  source = "../../modules/pubsub"

  project_id   = var.project
  environment  = var.environment
  topic_name   = "cache-topic"
  subscription_name = "cache-subscription"

  # Optional configurations
  message_retention_duration = "604800s"  # 7 days
  ack_deadline_seconds      = 600         # 10 minutes
  enable_message_ordering   = false
}

module "github_actions_iam" {
  source = "../../modules/iam"
  
  project_id             = var.project
  region                 = var.region
  artifact_registry_name = var.repository_id
}

module "external_secrets" {
  source = "../../modules/external-secrets"

  project_id        = var.project
  cluster_name      = module.gke.cluster_name
  cluster_location  = var.region
  cluster_dependency = data.google_container_cluster.primary
}

