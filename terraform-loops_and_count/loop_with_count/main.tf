# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate count concept in Terraform
# About: The count argument allows you to specify the number of instances of a resource to create. It's useful when you want to create multiple identical resources.
# DATE: 21-08-2024
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

#No variables provided!

#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------
# Start  nginx container

resource "docker_container" "nginx" {
  #Use count variable  
  count = 3
  name  = "terraform-nginx-${count.index}"
  image = docker_image.nginx.image_id
  
  
#Map the host ports to container port 80
   ports {
    internal = 80
    external = 8085+count.index
  
}
}
#------------------------------------------------------------------CODE BLOCK END-------------------------------

#------------------------------------------------------------------OUTPUT BLOCK START-------------------------------

#Output the container details to the terminal

output "container_id" {
  description = "The ID of the Docker containers"
  value       = [for container in docker_container.nginx: container.id]
}

output "container_name" {
  description = "The name of the Docker containers"
  value       = [for container in docker_container.nginx: container.name]
}
#------------------------------------------------------------------OUTPUT BLOCK END-------------------------------
