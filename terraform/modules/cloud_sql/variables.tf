variable "instance_name" {
  type    = string
  default = "stooks-gke-app-private-db"
}

variable "network" {
  type = string
}

variable "db_name" {
  default     = "stooks-gke"
  description = "Database name"
  type        = string
}

variable "username" {
  default = "stooks-gke"
  type    = string
}

variable "password" {
  type = string
}

variable "region" {
  type = string
}

variable "project_id" {
  type = string
}