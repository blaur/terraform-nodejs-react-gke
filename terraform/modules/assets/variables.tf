variable "env" {
  type = string
}

variable "location" {
  default = "europe-north1"
  type    = string
}

variable "project_id" {
  type    = string
}


variable "storage_class" {
  default = "REGIONAL"
  type    = string
}