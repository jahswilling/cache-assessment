resource "kubernetes_namespace" "elastic_system" {
  metadata {
    name = "elastic-system"
  }
}

resource "helm_release" "eck_operator" {
  name       = "eck-operator"
  repository = "https://helm.elastic.co"
  chart      = "eck-operator"
  namespace  = kubernetes_namespace.elastic_system.metadata[0].name
  version    = "2.12.0"  # Using a stable version

  set {
    name  = "createClusterRole"
    value = "true"
  }

  set {
    name  = "createCustomResourceDefinitions"
    value = "true"
  }

  set {
    name  = "createServiceAccount"
    value = "true"
  }

  depends_on = [kubernetes_namespace.elastic_system]
}

# Elasticsearch cluster configuration
resource "kubernetes_manifest" "elasticsearch_cluster" {
  manifest = {
    apiVersion = "elasticsearch.k8s.elastic.co/v1"
    kind       = "Elasticsearch"
    metadata = {
      name      = var.elasticsearch_cluster_name
      namespace = var.namespace
    }
    spec = {
      version = var.elasticsearch_version
      nodeSets = [
        {
          name  = "default"
          count = var.node_count
          config = {
            "node.roles" = ["master", "data", "ingest"]
          }
          podTemplate = {
            spec = {
              containers = [
                {
                  name = "elasticsearch"
                  resources = {
                    requests = {
                      memory = var.memory_request
                      cpu    = var.cpu_request
                    }
                    limits = {
                      memory = var.memory_limit
                      cpu    = var.cpu_limit
                    }
                  }
                }
              ]
            }
          }
        }
      ]
    }
  }

  depends_on = [helm_release.eck_operator]
} 