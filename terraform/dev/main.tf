locals {
  env = "dev"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.74.0"
    }
  }

  required_version = ">= 0.14"
}

module "gke" {
  source = "../modules/gke"

  project_id            = "${var.project_id}"
  env                   = "${local.env}"
  image_tag             = "v1"
  image_tag_frontend    = "v1"
  machine_type          = "n1-standard-1"
  node_count            = "1"
  region                = "${var.region}"
}

module "cloud_sql" {
  source = "../modules/cloud_sql"

  network  = "${module.gke.network}"
  region   = "${var.region}"
  db_name  = "stooks-gke-${local.env}"
  username = "stooks-gke-${local.env}"
  password = "${var.db_password}"
  project_id = "${var.project_id}"
}

module "assets" {
  source = "../modules/assets"

  env      = "${local.env}"
  location = "${var.region}"
  project_id            = "${var.project_id}"
}

module "loadbalancer" {
  source = "../modules/loadbalancer"

  assets_bucket_name       = "${module.assets.bucket_name}"
  enable_cdn               = false
  k8s_backend_service_name = "${var.k8s_backend_service_name}"
  project_id               = "${var.project_id}"
}

module "dns" {
  source = "../modules/dns"

  domain                   = "${var.domain}"
  load_balancer_ip_address = "${module.loadbalancer.public_address}"
  project_id               = "${var.project_id}"
}

data "template_file" "k8sbackend" {
  template = "${file("${path.module}/../services/k8s.template.yaml")}"

  vars = {
    db_host      = "${module.cloud_sql.host}"
    db_name      = "${module.cloud_sql.db_name}"
    db_username  = "${module.cloud_sql.username}"
    db_password  = "${module.cloud_sql.password}"
    db_port      = "5432"
    image_url    = "${module.gke.image_url}"
    project_name = "stooks-gke-${local.env}"
  }
}

data "template_file" "k8sfrontend" {
  template = "${file("${path.module}/../services/react.k8s.template.yaml")}"

  vars = {
    backend_api_url = "${module.loadbalancer.public_address}"
    frontend_image_url    = "${module.gke.frontend_image_url}"
    project_name = "stooks-gke-${local.env}"
  }
}