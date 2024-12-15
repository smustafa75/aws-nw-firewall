
locals {
 all_vols= {
  "vol01" = {
    device_name         = "/dev/sdb",
    volume_type ="gp3",
    volume_size = var.hana_db_disk_sap
    #kms_key_id = var.kms_key_ebs
    delete_on_termination = "true"
    encrypted ="false"
  },
  "vol02" = {
    device_name         = "/dev/sdc",
    volume_type ="gp3",
    volume_size = var.hana_db_disk_shared
    #kms_key_id = var.kms_key_ebs
    delete_on_termination = "true"
    encrypted ="false"
  },
  "vol03" = {
    device_name         = "/dev/sdd",
    volume_type ="gp3",
    volume_size = var.hana_db_disk_data
    #kms_key_id = var.kms_key_ebs
    delete_on_termination = "true"
    encrypted ="false"
  },
  "vol04" = {
    device_name         = "/dev/sde",
    volume_type ="gp3",
    volume_size = var.hana_db_disk_log
    #kms_key_id = var.kms_key_ebs
    delete_on_termination = "true"
    encrypted ="false"
  }
  
  }
}


variable "disks_hana01" {
  type    = map(string)
  default = {}
}

resource "aws_instance" "hana_db01" {
  ami           = var.hana_db_ami01
  instance_type = var.instance_hana_db01
  key_name = "bastion_pair_01"
  vpc_security_group_ids = [ var.private_security_group ]
  subnet_id = var.private_net[0]


root_block_device {
  delete_on_termination = "true"
  encrypted = "true"
  volume_size = var.hana_db_disk_root
  volume_type = "gp3"
}


dynamic "ebs_block_device" {
 # for_each = merge(local.vols_hana_01,var.disks_hana01)
for_each = local.all_vols
  content  {
      volume_size= ebs_block_device.value.volume_size
      device_name = ebs_block_device.value.device_name
      volume_type= ebs_block_device.value.volume_type
      delete_on_termination= ebs_block_device.value.delete_on_termination
      encrypted = ebs_block_device.value.encrypted
 
  }
}

tags = {
  Name = "${var.project_name} - Hana_01"
}

}



resource "aws_instance" "hana_db02" {
  ami           = var.hana_db_ami02
  instance_type = var.instance_hana_db01
  key_name = "bastion_pair_01"
  vpc_security_group_ids = [ var.private_security_group ]
  subnet_id = var.private_net[0]

root_block_device {
  delete_on_termination = "true"
  encrypted = "true"
  volume_size = var.hana_db_disk_root
  volume_type = "gp3"
}


dynamic "ebs_block_device" {
 # for_each = merge(local.vols_hana_01,var.disks_hana01)
for_each = local.all_vols
  content  {
      volume_size= ebs_block_device.value.volume_size
      device_name = ebs_block_device.value.device_name
      volume_type= ebs_block_device.value.volume_type
      delete_on_termination= ebs_block_device.value.delete_on_termination
      encrypted = ebs_block_device.value.encrypted
 
  }
}

tags = {
  Name = "${var.project_name} - Hana_02"
}

}

/*
resource "aws_instance" "hana_app" {
  ami           = var.hana_app_ami
  instance_type = var.instance_hana_app
  key_name = "bastion_pair_01"
  vpc_security_group_ids = [ var.private_security_group ]
  subnet_id = var.private_net[0]


root_block_device {
  delete_on_termination = "true"
  encrypted = "true"
  volume_size = var.hana_app_disk
  volume_type = "gp3"
}


tags = {
  Name = "${var.project_name} - App Server"
}

}

*/
resource "aws_eip" "bastion_eip" {
  vpc = true
  tags = {
    Name = "EIP - ${var.project_name}"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.bastion_ami
  instance_type = var.instance_bastion
  key_name = "bastion_pair_01"
  vpc_security_group_ids = [ var.public_security_group ]
  subnet_id = var.public_net[0]

root_block_device {
  delete_on_termination = "true"
  encrypted = "true"
  volume_size = var.bastion_disk
  volume_type = "gp3"
}

tags = {
  Name = "${var.project_name} - Bastion Server"
}

}

resource "aws_eip_association" "eip-association" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion_eip.id
}

resource "aws_instance" "web_sap" {
  ami           = var.web_sap_ami
  instance_type = var.instance_web_sap
  key_name = "bastion_pair_01"
  vpc_security_group_ids = [ var.public_security_group ]
  subnet_id = var.public_net[0]

root_block_device {
  delete_on_termination = "true"
  encrypted = "true"
  volume_size = var.web_sap_disk
  volume_type = "gp3"
}


tags = {
  Name = "${var.project_name} - SAP Router Server"
}

}
