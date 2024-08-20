# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: To create a Docker container using Module concept. This the the container creation module
# DATE: 20-08-2024
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

#Specift the Image to use
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

#Create the container
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = var.container_name

  ports {
    internal = var.internal_port
    external = var.external_port
  }
  # Explicit dependency on the image
  depends_on = [docker_image.nginx]

#Attach the volume. This volume will be created by separate module named: "volume creation"
  volumes {
    volume_name    = var.volume_name

    #path to attach the volume to
    container_path = var.container_path
  }
}
