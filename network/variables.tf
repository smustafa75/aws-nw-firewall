variable "vpc_cidr" {
default =""
}

variable "firewall_subnet" {
  type = list(string)
  #default = []
}

variable "workload_subnet" {
  type = list(string)
  #default = []
}

variable "nat_gw_subnet" {
  type = list(string)
  #default = []
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
