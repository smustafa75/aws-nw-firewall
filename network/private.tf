
resource "aws_default_route_table" "tf_private_rt" {
  
  default_route_table_id = aws_vpc.tf_vpc.default_route_table_id
  #propagating_vgws = [ aws_vpn_gateway.vpg-alsafadi.id ]
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id             = aws_nat_gateway.nat_gw.id
  }
   
  tags = {
    Name = "Private RT - ${var.project_name}"
  }
}



resource "aws_subnet" "tf_private_subnet" {
  count = 2
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.private_subnets[count.index]
  #cidr_block              = var.private_subnets[0]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  #availability_zone       = data.aws_availability_zones.available.names[0]


  tags = {
    Name = "Private Subnet - ${var.project_name}"
  }
}


resource "aws_route_table_association" "tf_private_assoc" {
  count          = length(aws_subnet.tf_private_subnet)
  #subnet_id      = aws_subnet.tf_private_subnet.id
  subnet_id = aws_subnet.tf_private_subnet.*.id[count.index]
  route_table_id = aws_default_route_table.tf_private_rt.id  
}


resource "aws_security_group" "tf_private_sg" {
  name        = "tf_private_sg"
  description = "Access instances in private subnet"
  vpc_id      = aws_vpc.tf_vpc.id

 /* ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]

  }*/
ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
  }
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
    ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
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
}

resource "aws_vpc_endpoint" "ec2-msgs-endpt" {
  vpc_id            = aws_vpc.tf_vpc.id
  service_name      = "com.amazonaws.${var.region_info}.ec2messages"
  vpc_endpoint_type = "Interface"
  private_dns_enabled   = true

  security_group_ids = [
    aws_security_group.tf_private_sg.id,
  ]
  #private_dns_enabled = true
  #tags = var.tags
}
resource "aws_vpc_endpoint_subnet_association" "ec2-msgs-assoc" {
  count = length(aws_subnet.tf_private_subnet)
  vpc_endpoint_id = aws_vpc_endpoint.ec2-msgs-endpt.id
  subnet_id       = aws_subnet.tf_private_subnet.*.id[count.index]
}

resource "aws_vpc_endpoint" "ssm-endpt" {
  vpc_id            = aws_vpc.tf_vpc.id
  service_name      = "com.amazonaws.${var.region_info}.ssm"
  vpc_endpoint_type = "Interface"
  private_dns_enabled   = true

  security_group_ids = [
    aws_security_group.tf_private_sg.id,
  ]
  #private_dns_enabled = true
  #tags = var.tags
}
resource "aws_vpc_endpoint_subnet_association" "ssm-assoc" {
  count = length(aws_subnet.tf_private_subnet)
  vpc_endpoint_id = aws_vpc_endpoint.ssm-endpt.id
  subnet_id       = aws_subnet.tf_private_subnet.*.id[count.index]
}

resource "aws_vpc_endpoint" "ssm-msgs-endpt" {
  vpc_id            =  aws_vpc.tf_vpc.id
  service_name      = "com.amazonaws.${var.region_info}.ssmmessages"
  vpc_endpoint_type = "Interface"
  private_dns_enabled   = true

  security_group_ids = [
    aws_security_group.tf_private_sg.id,
  ]
  #private_dns_enabled = true
  #tags = var.tags
}
resource "aws_vpc_endpoint_subnet_association" "ssm-msgs-assoc" {
  count = length(aws_subnet.tf_private_subnet)
  vpc_endpoint_id = aws_vpc_endpoint.ssm-msgs-endpt.id
  subnet_id       = aws_subnet.tf_private_subnet.*.id[count.index]
}
*/

resource "random_id" "log_group_id" {
  byte_length = 2

}

resource "aws_flow_log" "flow_log_config" {
  #iam_role_arn    = aws_iam_role.poc-vpc-flow-log-role.arn
  log_destination = var.logging_bucket
  log_destination_type ="s3"
  max_aggregation_interval = 60
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.tf_vpc.id
  destination_options {
    file_format = "plain-text"
    hive_compatible_partitions = false
    per_hour_partition = false
  }
}

resource "aws_cloudwatch_log_group" "poc-vpc-flow-log" {
  name = "${var.project_name}-vpc-flow-log-${random_id.log_group_id.dec}"
}

resource "aws_iam_role" "poc-vpc-flow-log-role" {
  name = "${var.project_name}-vpc-flow-log-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "poc-vpc-flow-log-policy" {
  name = "${var.project_name}-vpc-flow-log-policy"
  role = aws_iam_role.poc-vpc-flow-log-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

