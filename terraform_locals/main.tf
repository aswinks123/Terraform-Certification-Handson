# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate locals concept in Terraform
# About: locals are used to define values that are derived from other variables or resources. They help simplify complex expressions or calculations and avoid repeating the same logic multiple times within your configuration.
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
#------------------------------------------------------------------LOCALS BLOCK START-------------------------------
#Defining the locals
locals {
  env  = "production"
  team_name = "DevOps_team"
  #We can reference this app_name in all locations in this program. We use it to create container name and volume name.
  
  app_name = "${local.team_name}-${local.env}"
}
#------------------------------------------------------------------LOCALS BLOCK END-------------------------------

#------------------------------------------------------------------VARIABLE BLOCK START-------------------------------
#Using variable to provide internal and external port

variable "internal_port" {
    description = "Internal port of the container"
    type = number
    default = 80
}
variable "external_port"{
    description = "external port of the container"
    type = number
    default = 5000
}
#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------
# Start multiple nginx container
resource "docker_container" "nginx" {
  
  name  = local.app_name
  image = docker_image.nginx.image_id

#Map the host port 5000 to container port 80
   ports {
    internal = var.internal_port
    external = var.external_port
  }
}

#Create a Volume
resource "docker_volume" "docker_volume1" {
  #using the locals to create the name.  
  name = local.app_name
}
#------------------------------------------------------------------CODE BLOCK END-------------------------------

#------------------------------------------------------------------OUTPUT BLOCK START-------------------------------

#Output the container details to the terminal

output "container_id" {
  description = "The ID of the Docker containers"
  value       = docker_container.nginx.id
}

output "container_name" {
  description = "The name of the Docker containers"
  value       = docker_container.nginx.name
}

output "volume_name" {
  description = "The name of the volume created"
  value       = docker_volume.docker_volume1.name
}
#------------------------------------------------------------------OUTPUT BLOCK END-------------------------------
