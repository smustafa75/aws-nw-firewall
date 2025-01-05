resource "aws_instance" "private_instance" {
  ami           = var.private_ami
  instance_type = var.private_instance
  iam_instance_profile = var.instance_profile
  vpc_security_group_ids = [ var.private_security_group ]
  subnet_id = var.workload_net[0]

root_block_device {
  delete_on_termination = "true"
  encrypted = "true"
  volume_size = var.private_disk
  volume_type = "gp3"
}

tags = {
  Name = "${var.project_name} - Private Server"
}

}
