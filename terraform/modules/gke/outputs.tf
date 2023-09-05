output "cluster_name" {
  value = "${google_container_cluster.gke_cluster.name}"
}

output "image_url" {
  value = "${data.google_container_registry_image.default.image_url}"
}

output "frontend_image_url" {
  value = "${data.google_container_registry_image.default_frontend.image_url}"
}

output "network" {
  value = "${data.google_compute_network.default.self_link}"
}