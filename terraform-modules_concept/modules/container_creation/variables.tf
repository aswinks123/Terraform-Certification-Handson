#Variables for the main.tf file. values will be provided from the primary main.tf file from where this module is called.

variable "container_name" {
  description = "Name of the Docker container"
  type        = string
}

variable "internal_port" {
  description = "Internal port for Docker container"
  type        = number
}

variable "external_port" {
  description = "External port for Docker container"
  type        = number
}

variable "volume_name" {
  description = "Name of the Docker volume to attach"
  type        = string
}

variable "container_path" {
  description = "Path inside the container to mount the volume"
  type        = string
}
