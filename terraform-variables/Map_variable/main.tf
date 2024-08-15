# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate MAP variable in Terraform
# DATE: 15-08-2024
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

#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------
#Using basic variable to provide container name and port

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

#Variable as list of string - passing envs to container

variable "container_names" {
  description = "A list of names for the containers"
  type        = list(string)
  default     = ["container-1", "container-2", "container-3"]
}


#MAP variable
# MAP variable to inject multiple ENV inside the container

variable "env_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {    
    "ENV"   = "Production"
    "OWNER" = "Aswin"
    "TOPIC" = "Terraform"
  }
}

#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------
# Start multiple nginx container
resource "docker_container" "nginx" {

  #To use the list variable to create multiple containers
  count = length(var.container_names)
  name  = var.container_names[count.index]
  image = docker_image.nginx.image_id

#Map the host port variable to container port variable. Here we uses count.index to increment the external port 

 ports {
    internal = var.internal_port
    external = var.external_port + count.index
  }
}

#------------------------------------------------------------------CODE BLOCK END-------------------------------

#------------------------------------------------------------------OUTPUT BLOCK START-------------------------------

#we use  [*].id to refer elements of list
output "container_ids" {
  description = "The IDs of the created containers"
  value       = docker_container.nginx[*].id   
}

output "container_names" {
  description = "The names of the created containers"
  value       = docker_container.nginx[*].name
}

#------------------------------------------------------------------OUTPUT BLOCK END-------------------------------