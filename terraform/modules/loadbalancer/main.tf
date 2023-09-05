locals {
  url_map_name = "stooks-gke-url-map"
  url_map_name_api_assets = "stooks-gke-url-map-assets-api"
}

resource "google_compute_backend_service" "stooks_backend" {
  # count     = "${var.k8s_backend_service_name == "" ? 0 : 1}"
  name        = "${var.k8s_backend_service_name}"
  project     = var.project_id
}

resource "google_compute_backend_bucket" "assets" {
  name        = "assets-backend"
  bucket_name = "${var.assets_bucket_name}"
  enable_cdn  = "${var.enable_cdn}"
  project = var.project_id
}

resource "google_compute_global_address" "default" {
  project = var.project_id
  name = "stooks-gke-public-address"
}

resource "google_compute_url_map" "assets_only" {
  project         = var.project_id
  # count         = "${var.k8s_backend_service_name == "" ? 1 : 0}"
  name            = "${local.url_map_name}"
  default_service = "${google_compute_backend_bucket.assets.self_link}"
}

resource "google_compute_url_map" "assets_and_api" {
  project         = var.project_id
  # count          = "${var.k8s_backend_service_name == "" ? 0 : 1}"
  name            = "${local.url_map_name_api_assets}"
  default_service = "${google_compute_backend_bucket.assets.self_link}"

  host_rule {
    hosts        = ["*"]
    path_matcher = "default"
  }

  path_matcher {
    name            = "default"
    default_service = "${google_compute_backend_bucket.assets.self_link}"

    path_rule {
      paths   = ["/api", "/api/*"]
      service = "${google_compute_backend_service.stooks_backend.self_link}"
    }
  }
}

resource "google_compute_target_http_proxy" "default" {
  name      = "stooks-gke-http-proxy"
  project   = var.project_id  
  # Workaround over Terraform's lack of conditional resources; will be resolved in upcoming version:
  url_map = "${var.k8s_backend_service_name == "" ?  join(" ", google_compute_url_map.assets_only.*.self_link) : join(" ", google_compute_url_map.assets_and_api.*.self_link)}"
}

resource "google_compute_global_forwarding_rule" "default" {
  project    = var.project_id  
  name       = "stooks-gke-forwarding-rule"
  ip_address = "${google_compute_global_address.default.address}"
  target     = "${google_compute_target_http_proxy.default.self_link}"
  port_range = "80"
}