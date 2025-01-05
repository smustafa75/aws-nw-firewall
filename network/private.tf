
resource "aws_security_group" "private_sg" {
  name        = "private_sg_fw"
  description = "Access instances in private subnet"
  vpc_id      = aws_vpc.fw_vpc.id

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
  }
ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
        description      = ""
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  } 
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [ "0.0.0.0/0"]
    description      = ""
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
resource "aws_vpc_endpoint" "kms-endpt" {
  vpc_id            = aws_vpc.tf_vpc.id
  service_name      = "com.amazonaws.${var.region_info}.kms"
  vpc_endpoint_type = "Interface"
  private_dns_enabled   = true

  security_group_ids = [
    aws_security_group.tf_private_sg.id,
  ]
  #private_dns_enabled = true
  #tags = var.tags
}
resource "aws_vpc_endpoint_subnet_association" "kms-assoc" {
  count = length(aws_subnet.tf_private_subnet)
  vpc_endpoint_id = aws_vpc_endpoint.kms-endpt.id
  subnet_id       = aws_subnet.tf_private_subnet.*.id[count.index]
}*/

resource "aws_vpc_endpoint" "ec2-msgs-endpt" {
  vpc_id            = aws_vpc.fw_vpc.id
  service_name      = "com.amazonaws.${var.region_info}.ec2messages"
  vpc_endpoint_type = "Interface"
  private_dns_enabled   = true

  security_group_ids = [
    aws_security_group.private_sg.id,
  ]
  #private_dns_enabled = true
  #tags = var.tags
}
resource "aws_vpc_endpoint_subnet_association" "ec2-msgs-assoc" {
  count = length(aws_subnet.workload_subnet)
  vpc_endpoint_id = aws_vpc_endpoint.ec2-msgs-endpt.id
  subnet_id       = aws_subnet.workload_subnet.*.id[count.index]
}

resource "aws_vpc_endpoint" "ssm-endpt" {
  vpc_id            = aws_vpc.fw_vpc.id
  service_name      = "com.amazonaws.${var.region_info}.ssm"
  vpc_endpoint_type = "Interface"
  private_dns_enabled   = true

  security_group_ids = [
    aws_security_group.private_sg.id,
  ]
  #private_dns_enabled = true
  #tags = var.tags
}
resource "aws_vpc_endpoint_subnet_association" "ssm-assoc" {
  count = length(aws_subnet.workload_subnet)
  vpc_endpoint_id = aws_vpc_endpoint.ssm-endpt.id
  subnet_id       = aws_subnet.workload_subnet.*.id[count.index]
}

resource "aws_vpc_endpoint" "ssm-msgs-endpt" {
  vpc_id            =  aws_vpc.fw_vpc.id
  service_name      = "com.amazonaws.${var.region_info}.ssmmessages"
  vpc_endpoint_type = "Interface"
  private_dns_enabled   = true

  security_group_ids = [
    aws_security_group.private_sg.id,
  ]
  #private_dns_enabled = true
  #tags = var.tags
}
resource "aws_vpc_endpoint_subnet_association" "ssm-msgs-assoc" {
  count = length(aws_subnet.workload_subnet)
  vpc_endpoint_id = aws_vpc_endpoint.ssm-msgs-endpt.id
  subnet_id       = aws_subnet.workload_subnet.*.id[count.index]
}
