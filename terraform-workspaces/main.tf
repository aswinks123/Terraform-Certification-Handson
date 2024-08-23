# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate terraform workspace concept 
# About: Terraform workspaces are a feature that allows you to manage multiple states within a single configuration, providing a way to work with different environments (e.g., development, staging, production) using the same configuration files.
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

provider "docker" {}

# Find the latest nginx image.
resource "docker_image" "nginx" {
  name = "nginx:latest"

}
#------------------------------------------------------------------VARIABLE BLOCK START-------------------------------
# Variables
variable "internal_port" {
  description = "Internal port of the container"
  type        = number
  default     = 80
}

variable "external_port" {
  description = "External port of the container"
  type        = map(number)
  default     = {
    dev  = 8080
    test = 8081
    prod = 8082
  }
}

variable "container_names" {
  description = "Map of workspace names to container names"
  type        = map(string)
  default = {
    dev  = "dev-container"
    test = "test-container"
    prod = "prod-container"
  }
}
#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------
# Start nginx container
resource "docker_container" "nginx" {
  name   = lookup(var.container_names, terraform.workspace, "default-workspace-container")
  image  = docker_image.nginx.image_id
  
  ports {
    internal = var.internal_port
    external = lookup(var.external_port,terraform.workspace,9000)
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