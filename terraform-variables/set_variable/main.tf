# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Demonstrate SET variable in Terraform
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

#Variable as "SET" of string 
#SET will not allow duplicates. So it can be used for adding container names and make sure duplicate name doesn't exist
#IF 2 same name is given, it will not throw error but it just ignore the duplicate name.

variable "container_names" {
  description = "A list of names for the containers"
  type        = set(string)
  default     = ["container-1", "container-2", "container-2"]
}
#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------
# Start multiple nginx container
resource "docker_container" "nginx" {

  #To use the list variable to create multiple containers
  count = length(var.container_names)

  #As set is unordered, we cannot use index to fetch elements. We first convert SET into list and then use it.
  name  = tolist(var.container_names)[count.index]  # Access by index after conversion to list
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