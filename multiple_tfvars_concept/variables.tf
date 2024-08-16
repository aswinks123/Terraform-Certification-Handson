#variable.tf file
#As we are using the concept of terraform.tfvars the values of the variables that we declare here are provided from a file 
#named : production.tfvars and development.tfvars files


#------------------------------------------------------------------VARIABLE BLOCK START-------------------------------
#Using basic variable to provide container name and port

variable "internal_port" {
    description = "Internal port of the container"
    type = number
  
}
variable "external_port"{
    description = "external port of the container"
    type = number
 
}

variable "container_name" {
    description = "Name of the container"
    type = string
  
}
#------------------------------------------------------------------VARIABLE BLOCK END-------------------------------
