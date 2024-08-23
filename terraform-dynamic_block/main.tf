# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate Dynamic concept in Terraform
# About: This Dynamic block program will open multiple ports of a container. Dynamic block is like a loop that loops a block of code multiple times.
# DATE: 23-08-2024
# =============================================================================

# Specify the Provider block. Here we use Docker

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  # Provider configuration can be added here if needed
}

# Find the latest nginx image.

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

#------------------------------------------------------------------VARIABLE BLOCK START-------------------------------

# Dynamic block uses this variable block to fetch the values of port
variable "container_ports" {
  description = "Port number to be opened"
  type        = list(number)
  default     = [8080, 8081, 8082, 8084]
}

#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------

# Start nginx containers

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "nginx_multiple_port_container"

# Dynamic block. Here it will iterate over a variable list of ports that we already created and assigned one by one.
  dynamic "ports" {
    for_each = var.container_ports
    content {
      internal = 80
      #it iterated the value of port. ie, first ports=8081 then ports=8082....
      external = ports.value
    }
  }
}

#------------------------------------------------------------------CODE BLOCK END-------------------------------

#------------------------------------------------------------------OUTPUT BLOCK START-------------------------------

# Output the container details to the terminal

output "container_id" {
  description = "The ID of the Docker container"
  value       = docker_container.nginx.id
}

output "container_name" {
  description = "The name of the Docker container"
  value       = docker_container.nginx.name
}

#------------------------------------------------------------------OUTPUT BLOCK END-------------------------------
