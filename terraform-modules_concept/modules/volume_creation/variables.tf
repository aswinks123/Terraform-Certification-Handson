#Variables for the main.tf file. values will be provided from the primary main.tf file from where this module is called.
variable "volume_name" {
    description = "Name of the docker volume"
    type = string  
}