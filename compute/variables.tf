
variable "private_instance" {}
variable "private_ami" {}
variable "private_disk" {}

variable "aws_region" {
}
variable "private_security_group" {
# default = ""  
}

variable "public_security_group" {
# default =""
}

variable "instance_profile" {
#  default = []  
}

variable "workload_net" {
#type    = list(string)
#  default = []
   }

variable "vpc_id" {
   
}

variable "project_name" {}

