variable "vpc_cidr" {
default =""
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "public_subnets" {
  type    = list(string)
  default = []

}

variable "accessip" {
  default = "0.0.0.0/0"
}

variable "region_info" {
default = ""
  
}

variable "logging_bucket" {
default = ""
}
variable "project_name" {}
