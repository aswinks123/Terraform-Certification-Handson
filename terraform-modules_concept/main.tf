# =============================================================================
# DEVELOPER: Aswin KS
# PURPOSE: Primary main.tf file. We call all the other modules from this file
# DATE: 20-08-2024
# =============================================================================

#Calling the "volume_creation" module that will create the docker volume
module "myvolume" {

  #path of the volume_creation main.tf file
  source = "./modules/volume_creation"
  #Provide the values for variables.tf file of "volume_creation" module
  volume_name = "docker_volume1"
}

#Calling the "container_creation" module that will create the docker container
module "mycontainer" {
  #path of the container_creation main.tf file
  source = "./modules/container_creation"

  #Provide the values for variables.tf file of "container_creation" module
  container_name = "nginx-server"
  internal_port  = 80
  external_port  = 8080
  #Specify the docker volume that we created and attach it to the container
  volume_name    = module.myvolume.volume_name
  container_path = "/usr/share/nginx/html"
}

