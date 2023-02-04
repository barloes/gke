variable "machine_type" {
  type        = string
  description = "machine type of server"
}

variable "node_count" {
  type        = number
  description = "number of nodes"
}

variable "location" {
  type    = string
}

variable "display_name" {
  type    = string
}

variable "label" {
  type    = string
  default = "test"
}

variable "environment" {
  type = string
}

variable "project_id" {
  type = string
  default = "poc-testing-personal"
}

variable "disk_size_gb" {
  type = number
}





