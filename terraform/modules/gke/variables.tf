variable "env" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "image_tag_frontend" {
  type = string
}

variable "machine_type" {
  default = "n1-standard-1"
  type    = string
}

variable "project_id" {
  type = string
}

variable "node_count" {
  default = "1"
  type    = string
}

variable "region" {
  type = string
}