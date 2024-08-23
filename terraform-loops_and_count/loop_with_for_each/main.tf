# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate for_each concept in Terraform
# About: The for_each argument allows you to create multiple instances of a resource based on a map or a set of values. 
# DATE: 21-08-2024
# =============================================================================

# Specify the Provider block. Here we use Docker

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

variable "container_ports" {
  description = "A set of ports for mapping host to container ports"
  type        = set(string)
  default     = ["8085", "8086", "8087", "8089"]
}

#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------
# Start nginx containers

resource "docker_container" "nginx" {
  #for_each works only with set or MAP. so it need to be converted incase if it is a list
  for_each = toset(var.container_ports)

  name  = "terraform-nginx-${each.value}"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    #each.value contains the value of each element of the set. one at a time each loop
    external = each.value
  }
}

#------------------------------------------------------------------CODE BLOCK END-------------------------------

#------------------------------------------------------------------OUTPUT BLOCK START-------------------------------

# Output the container details to the terminal

output "container_id" {
  description = "The ID of the Docker containers"
  value       = [for container in docker_container.nginx : container.id]
}

output "container_name" {
  description = "The name of the Docker containers"
  value       = [for container in docker_container.nginx : container.name]
}

#------------------------------------------------------------------OUTPUT BLOCK END-------------------------------

