# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: To create a Docker volume using Module concept
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

#Create a Volume

resource "docker_volume" "docker_volume1" {
  name = var.volume_name
}


