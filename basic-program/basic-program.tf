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

variable "container_name" {
    description = "Name of the container"
    type = string
    default = "terraform-nginx"
}


#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------


# Start multiple nginx container


resource "docker_container" "nginx" {

  
  name  = var.container_name
  image = docker_image.nginx.image_id

#Map the host port 5000 to container port 80
   ports {
    internal = var.internal_port
    external = var.external_port
  }

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


#------------------------------------------------------------------OUTPUT BLOCK END-------------------------------
