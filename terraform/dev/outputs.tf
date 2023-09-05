output "cluster_name" {
  value = "${module.gke.cluster_name}"
}

output "domain" {
   value = "${var.domain}"
}

output "image_url" {
  value = "${module.gke.image_url}"
}

output "frontend_image_url" {
  value = "${module.gke.frontend_image_url}"
}

output "network" {
  value = "${module.gke.network}"
}

output "k8s_rendered_template_backend" {
  value     = "${data.template_file.k8sbackend.rendered}"
  sensitive = true
}

output "k8s_rendered_template_frontend" {
  value     = "${data.template_file.k8sfrontend.rendered}"
  sensitive = true
}

output "k8s_backend_service_name" {
  value = "${var.k8s_backend_service_name}"
}

output "project_id" {
  value = "${var.project_id}"
}

output "static_assets_bucket_url" {
  value = "${module.assets.bucket_url}"
}

output "urlmap_name" {
  value = "${module.loadbalancer.urlmap_name}"
}

output "region" {
  value = "${var.region}"
}