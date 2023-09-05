variable "assets_bucket_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "enable_cdn" {
  type    = string
  default = false
}

variable "k8s_backend_service_name" {
  type    = string
}