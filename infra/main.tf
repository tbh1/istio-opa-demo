provider "google" {
  project = "${var.google_project_id}"
  region  = "${var.default_region}"
}

provider "google-beta" {
  project = "${var.google_project_id}"
  region  = "${var.default_region}"
}

resource "google_container_cluster" "primary" {
  provider                 = "google-beta"
  name                     = "istio-auth-demo"
  location                 = "${var.default_region}"
  initial_node_count       = 1
  remove_default_node_pool = true

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    istio_config {
      disabled = false
      auth     = "AUTH_MUTUAL_TLS"
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "istio-auth-demo"
  location   = "${var.default_region}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
