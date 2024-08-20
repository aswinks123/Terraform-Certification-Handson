#Print the container name as output

output "container_id" {
  description = "ID of the Docker container created is: "
  value       = docker_container.nginx.id
}
