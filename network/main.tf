data "aws_availability_zones" "available" {}

resource "aws_vpc" "fw_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.project_name
  }
}

//NAT GW
//******



resource "aws_eip" "nat_gw_eip" {
  depends_on = [
    aws_route_table_association.tf_public_assoc
  ]
  vpc = true
  tags = {
    Name = "EIP - ${var.project_name}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on = [
    aws_eip.tf_nat_gw_eip,
    aws_subnet.tf_public_subnet
  ]
  allocation_id = aws_eip.tf_nat_gw_eip.id
  #subnet_id = element(aws_vpc.tf_vpc.tf_public_subnet[count.index])
  subnet_id = aws_subnet.tf_public_subnet[0].id
  tags = {
    Name = "NATGW - ${var.project_name}"
  }
}


//IGW onward
//**********

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.tf_vpc.id 

  tags = {
    Name = "FW IGW - ${var.project_name}"
  }
}

//SUBNETS
//*******
resource "aws_subnet" "nat_gw_subnet" {
  count = 2
  vpc_id                  = aws_vpc.fw_vpc.id
  cidr_block              = var.nat_gw_subnet[count.index]
  map_public_ip_on_launch = false
  #availability_zone       = data.aws_availability_zones.available.names[count.index]
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "NAT GW Subnet - ${var.project_name}"
  }
}

resource "aws_subnet" "firewall_subnet" {
  count = 1
  vpc_id                  = aws_vpc.fw_vpc.id
  cidr_block              = var.firewall_subnet[count.index]
  map_public_ip_on_launch = false
  #availability_zone       = data.aws_availability_zones.available.names[count.index]
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "FW Subnet - ${var.project_name}"
  }
}

resource "aws_subnet" "workload_subnet" {
  count = 1
  vpc_id                  = aws_vpc.fw_vpc.id
  cidr_block              = var.workload_subnet[count.index]
  map_public_ip_on_launch = false
  #availability_zone       = data.aws_availability_zones.available.names[count.index]
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "Workload Subnet - ${var.project_name}"
  }
}

//ROUTE TABLES
//************
//private-rt
resource "aws_vpc_endpoint" "s3_endpoint" {
    vpc_id = aws_vpc.fw_vpc.id
    service_name = "com.amazonaws.${var.region_info}.s3"
}

resource "aws_route_table_association" "tf_private_assoc" {
  count          = length(aws_subnet.workload_subnet)
  #subnet_id      = aws_subnet.tf_private_subnet.id
  subnet_id = aws_subnet.workload_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_rt.id  
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.fw_vpc.id
route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id             = aws_nat_gateway.nat_gw.id
  }   
  tags = {
    Name = "NAT GW RT - ${var.project_name}"
  }
}

//natgw-route-table

resource "aws_route_table" "natgw_route_table" {
  vpc_id = aws_vpc.fw_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    //*****************REPLACE GW ID WITH FW GWLB*****************
    gateway_id = aws_internet_gateway.tf_internet_gw.id 

  }

  tags = {
    Name = "NAT GW RT - ${var.project_name}"
  }
}

resource "aws_route_table_association" "nat_gw_subnet_assoc" {
  count          = length(aws_subnet.nat_gw_subnet)
  #subnet_id      = aws_subnet.tf_private_subnet.id
  subnet_id = aws_subnet.nat_gw_subnet.*.id[count.index]
  route_table_id = aws_route_table.natgw_route_table.id  
}

resource "aws_route_table_association" "tf_natgw_assoc" {
  count          = length(aws_subnet.nat_gw_subnet)
  subnet_id      = aws_subnet.nat_gw_subnet.*.id[count.index]
  route_table_id = aws_route_table.natgw_route_table.id
}
