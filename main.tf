resource "google_service_account" "default" {
  account_id   = "${var.display_name}-id"
  display_name = "${var.display_name} Service Account"
  project      = var.project_id
}

resource "google_container_cluster" "primary" {

  project  = var.project_id
  name     = "${var.display_name}-cluster"
  location = var.location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true

  cluster_autoscaling {
    auto_provisioning_defaults {
      disk_size = var.disk_size_gb
    }
  }

  node_pool {
    node_config {
      disk_size_gb = var.disk_size_gb
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.display_name}-node-pool"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    preemptible  = true
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = [var.environment, var.display_name]
    labels = {
      environment = var.environment
      name        = var.display_name
    }
  }
}
