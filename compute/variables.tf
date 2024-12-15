variable "instance_hana_db01" {}
variable "hana_db_ami01" {}
variable hana_db_disk_root{}
variable hana_db_disk_sap{}
variable hana_db_disk_shared{}
variable hana_db_disk_data{}
variable hana_db_disk_log{}

variable "instance_hana_db02" {}
variable "hana_db_ami02" {}


variable instance_hana_app {}
variable hana_app_ami {}
variable hana_app_disk {}


variable instance_bastion {}
variable bastion_ami {}
variable bastion_disk{}

variable instance_web_sap  {}
variable web_sap_ami {}
variable web_sap_disk {}

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

variable "private_net" {
#type    = list(string)
#  default = []
   }

variable "public_net" {
#type    = list(string)
#  default = []
   }

variable "vpc_id" {
   
}

variable "project_name" {}

