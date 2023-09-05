# GKE cluster
data "google_container_engine_versions" "gke_version" {
  provider       = google
  location = "${var.region}"
  version_prefix = "1.27."
  project = var.project_id
}

data "google_container_registry_image" "default" {
  name   = "stooks-gke-${var.env}"
  tag    = "${var.image_tag}"
  project = var.project_id
}

data "google_container_registry_image" "default_frontend" {
  name   = "stooks-gke-${var.env}-frontend"
  tag    = "${var.image_tag_frontend}"
  project = var.project_id
}

data "google_compute_network" "default" {
  name = "default"
  project = var.project_id
}

# GKE cluster
resource "google_container_cluster" "gke_cluster" {
  name     = "${var.project_id}-gke-${var.env}"
  location = var.region
  min_master_version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  project = var.project_id

  enable_autopilot = true
  initial_node_count = 1

  network    = data.google_compute_network.default.name
}