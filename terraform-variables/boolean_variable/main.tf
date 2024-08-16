# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate Boolean variable in Terraform
# DATE: 16-08-2024
# =============================================================================

#Specify the Provider block. Here we use Docker

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Find the latest nginx image.

resource "docker_image" "nginx" {
  name = "nginx:latest"
}
#------------------------------------------------------------------VARIABLE BLOCK START-------------------------------

#BOOLEAN variable to check whether to create the container

variable "is_enabled" {
  description = "Whether the container is enabled"
  type        = bool
  default     = true
}
#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------
# Start nginx container

resource "docker_container" "nginx" {
  count = var.is_enabled ? 1 : 0
  #if count is 0 then the remaining code is skipped and container will not be created.count is a special variable in Terraform
  name  = "nginx-container"
  image = docker_image.nginx.image_id
}
#------------------------------------------------------------------CODE BLOCK END-------------------------------

#------------------------------------------------------------------OUTPUT BLOCK START-------------------------------

output "container_enabled" {
  description = "Is the container enabled?"
  value       = var.is_enabled
}
#------------------------------------------------------------------OUTPUT BLOCK END-------------------------------
