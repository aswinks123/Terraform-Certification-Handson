# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate terraform data source concept 
# About: It provides information about the resources that are present in the infrastrucure. Here we will fetch the details of nginx image
# DATE: 23-08-2024
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

#------------------------------------------------------------------DATA BLOCK START-------------------------------
# Use the 'latest' tag
data "docker_image" "latest" {
  name = "nginx:latest"
}
#------------------------------------------------------------------DATA BLOCK END-------------------------------

#------------------------------------------------------------------OUTPUT BLOCK START-------------------------------

# Output the details of the Docker image
output "image_id" {
  description = "The ID of the Docker image"
  value       = data.docker_image.latest.id
}

output "image_name" {
  description = "The name of the Docker image"
  value       = data.docker_image.latest.name
}
output "repo_name" {
  description = "The name of the Docker image"
  value       = data.docker_image.latest.repo_digest
}
#------------------------------------------------------------------DATA BLOCK END-------------------------------