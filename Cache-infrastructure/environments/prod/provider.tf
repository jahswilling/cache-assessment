provider "google" {
  project = var.project
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

terraform {
  required_version = ">= 1.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.20, < 6"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.20, < 6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  backend "gcs" {
    bucket = "cache-dev-infra-state"
    prefix = "terraform/state"
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-network/v9.0.0"
  }
}

