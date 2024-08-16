# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate variable.tf concept in Terraform
# About: variable.tf file allows to declare variable separetly from the main program. variables are declared in a file named variable.tf
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

# Find the latest Ubuntu precise image.

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

#------------------------------------------------------------------CODE BLOCK START-------------------------------
# Start multiple nginx container
resource "docker_container" "nginx" {

  name  = var.container_name
  image = docker_image.nginx.image_id

#Map the host port variable to container port variable
   ports {
    internal = var.internal_port
    external = var.external_port
  }

}

#------------------------------------------------------------------CODE BLOCK END-------------------------------

#------------------------------------------------------------------OUTPUT BLOCK START-------------------------------

output "container_ids" {
  description = "The IDs of the created containers"
  value       = docker_container.nginx.id
}

output "container_names" {
  description = "The names of the created containers"
  value       = docker_container.nginx.name
}

#------------------------------------------------------------------OUTPUT BLOCK END-------------------------------