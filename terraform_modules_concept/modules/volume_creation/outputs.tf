#Print the volume name as output

output "volume_name" {
    description = "Name of the colume created is: "
    value = docker_volume.docker_volume1.name 
}