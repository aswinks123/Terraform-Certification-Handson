# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: To Demonstrate the working of multiple tfvars files
# EXPLANATION: we will deploy nginx container with different name and external port depending on the tfvars file.
#To apply use the flag terrafrom apply -var-file= <path to .tfvars file >
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