#variable.tf file


#------------------------------------------------------------------VARIABLE BLOCK START-------------------------------
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

variable "container_name" {
    description = "Name of the container"
    type = string
    default = "terraform-nginx"
}
#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------
