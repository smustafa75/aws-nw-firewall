variable "aws_region" {
  default = "eu-west-2"
}

variable "project_name" {
  default = "AWSNetworkFirewall"
}

variable "vpc_cidr" {
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

variable "instance_type" {
  default = ""
}

variable "instance_count" {
  default = 1
}

variable "flowlog_policy" {
  default = ""
}

variable "flowlog_role" {
  default = ""
}

variable "ssm_role" {
  default = ""
}

variable "instance_profile" {
  default = ""
}



variable "private_instance" {}
variable "private_ami" {}
variable "private_disk" {}