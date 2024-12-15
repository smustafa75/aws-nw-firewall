variable "aws_region" {
  default = "eu-west-1"
}

variable "project_name" {
  default = "ProjectInfrastructure"
}

variable "vpc_cidr" {
}


variable "private_subnets" {
  type = list(string)
  #default = []
}

variable "public_subnets" {
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

variable "policy_name" {
  default = ""
}

variable "role_name" {
  default = ""
}

variable "s3_policy" {
  default = ""
}

variable "instance_profile" {
  default = ""
}


variable "instance_hana_db01" {}
variable "hana_db_ami01" {}
variable hana_db_disk_root{}
variable hana_db_disk_sap{}
variable hana_db_disk_shared{}
variable hana_db_disk_data{}
variable hana_db_disk_log{}

variable "instance_hana_db02" {}
variable "hana_db_ami02" {}
variable "instance_hana_app" {}
variable "hana_app_ami" {}
variable "hana_app_disk" {}


variable "instance_bastion" {}
variable "bastion_ami" {}
variable "bastion_disk" {}

variable "instance_web_sap" {}
variable "web_sap_ami" {}
variable "web_sap_disk" {}