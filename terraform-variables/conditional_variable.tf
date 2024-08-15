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

#Variable as list of string - passing envs to container

variable "container_names" {
  description = "A list of names for the containers"
  type        = list(string)
  default     = ["container-1", "container-2"]
}


#MAP variable that uses the CONDITIONAL EXPRESSION

# Conditional expression inside the env_variables map
variable "env_variables" {
  description = "Environment variables for the container that uses conditional expression"
  type        = map(string)
  default     = {
    #if var.is_production  flag is true the it adds production else development    
    "ENV"   = var.is_production ? "production" : "development"
    "OWNER" = "Aswin"
    "TOPIC" = "Terraform"
  }
}

#CONDITIONAL EXPRESSION
# Variable to determine if the environment is production

variable "is_production" {
  description = "Boolean flag to indicate if the environment is production"
  type        = bool
  default     = true
}




#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------

#------------------------------------------------------------------CODE BLOCK START-------------------------------


# Start multiple nginx container


resource "docker_container" "nginx" {

  count = length(var.container_names)
  name  = var.container_names[count.index]
  image = docker_image.nginx.image_id

#Map the host port 5000 to container port 80
   ports {
    internal = var.internal_port
    external = var.external_port + count.index
  }

#Refering the MAP variable to inject the env variables
    env = [for k, v in var.env_variables : "${k}=${v}"]

}


#------------------------------------------------------------------CODE BLOCK END-------------------------------

#------------------------------------------------------------------OUTPUT BLOCK START-------------------------------

output "container_ids" {
  description = "The IDs of the created containers"
  value       = docker_container.nginx[*].id
}

output "container_names" {
  description = "The names of the created containers"
  value       = docker_container.nginx[*].name
}

#------------------------------------------------------------------OUTPUT BLOCK END-------------------------------