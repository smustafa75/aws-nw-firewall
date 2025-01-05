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
//  depends_on = [
//    aws_route_table_association.tf_public_assoc
//  ]
  vpc = true
  tags = {
    Name = "EIP - ${var.project_name}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on = [
    aws_eip.nat_gw_eip,
    aws_subnet.nat_gw_subnet
  ]
  allocation_id = aws_eip.nat_gw_eip.id
  #subnet_id = element(aws_vpc.tf_vpc.tf_public_subnet[count.index])
  subnet_id = aws_subnet.nat_gw_subnet[0].id
  tags = {
    Name = "NATGW - ${var.project_name}"
  }
}


//IGW onward
//**********

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.fw_vpc.id 

  tags = {
    Name = "FW IGW - ${var.project_name}"
  }
}

//SUBNETS
//*******
resource "aws_subnet" "nat_gw_subnet" {
  count = 1
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
    route_table_ids = [ aws_route_table.private-rt.id ]
}


resource "aws_route_table" "public-rt-2-internet" {
  vpc_id = aws_vpc.fw_vpc.id

route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id 
  }   

  tags = {
    Name = "PUBLIC RTI - ${var.project_name}"
  }
}


resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.fw_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "PRIVATE RT - ${var.project_name}"
  }
}

resource "aws_route_table" "natgw-rt" {
  vpc_id = aws_vpc.fw_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    //ADD ROUTE to FW GWLB
    //nat_gateway_id = aws_nat_gateway.nat_gw.id
    vpc_endpoint_id = tolist(aws_networkfirewall_firewall.network-firewall.firewall_status[0].sync_states)[0].attachment[0].endpoint_id
  }

  tags = {
    Name = "NATGW RT - ${var.project_name}"
  }
}

resource "aws_route_table" "igw-2-piublic-rt" {
  vpc_id = aws_vpc.fw_vpc.id

  route {
    cidr_block = "172.31.1.0/24"
    vpc_endpoint_id = tolist(aws_networkfirewall_firewall.network-firewall.firewall_status[0].sync_states)[0].attachment[0].endpoint_id
  }
route {
    cidr_block = "172.31.2.0/24"
    vpc_endpoint_id = tolist(aws_networkfirewall_firewall.network-firewall.firewall_status[0].sync_states)[0].attachment[0].endpoint_id
  }
route {
    cidr_block = "172.31.3.0/24"
    vpc_endpoint_id = tolist(aws_networkfirewall_firewall.network-firewall.firewall_status[0].sync_states)[0].attachment[0].endpoint_id
  }

  tags = {
    Name = "IGW2P RT - ${var.project_name}"
  }
}

//Add Edge Assoc to IGW

resource "aws_route_table_association" "igw-2-public-rt-assoc" {
  gateway_id     = aws_internet_gateway.internet_gw.id
  route_table_id = aws_route_table.igw-2-piublic-rt.id
}



//RT Associations


resource "aws_route_table_association" "public-rt-2-internet-assoc" {
  count          = length(aws_subnet.firewall_subnet)
  #subnet_id      = aws_subnet.tf_private_subnet.id
  subnet_id = aws_subnet.firewall_subnet.*.id[0]
  route_table_id = aws_route_table.public-rt-2-internet.id
}

resource "aws_route_table_association" "private-rt-assoc" {
  count          = length(aws_subnet.workload_subnet)
  #subnet_id      = aws_subnet.tf_private_subnet.id
  subnet_id = aws_subnet.workload_subnet.*.id[count.index]
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "natgw-rt-assoc" {
  count          = length(aws_subnet.nat_gw_subnet)
  #subnet_id      = aws_subnet.tf_private_subnet.id
  subnet_id = aws_subnet.nat_gw_subnet.*.id[count.index]
  route_table_id = aws_route_table.natgw-rt.id
}

resource "aws_networkfirewall_firewall" "network-firewall" {
  name                = "fw-${var.project_name}"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.nw-firewall-policy.arn
  vpc_id              = aws_vpc.fw_vpc.id
  subnet_mapping {
    subnet_id = aws_subnet.firewall_subnet[0].id
  }
  tags = {
    Name = "FW - ${var.project_name}"
  }

}



resource "aws_networkfirewall_rule_group" "group-01" {
  capacity    = 50
  description = "Permits icmp traffic from source"
  name        = "testing-statefull"
  type        = "STATEFUL"
  rule_group {
    rules_source {
      dynamic "stateful_rule" {
        for_each = local.ips
        content {
          action = "PASS"
          header {
            destination      = "ANY"
            destination_port = "ANY"
            protocol         = "ICMP"
            direction        = "ANY"
            source_port      = "ANY"
            source           = stateful_rule.value
          }
          rule_option {
            keyword  = "sid"
            settings = ["1"]
          }
        }
      }
    }
  }

  tags = {
   Name = "FW - ${var.project_name}"
  }
}

locals {
  ips = ["ANY"]
}

resource "aws_networkfirewall_rule_group" "stateless-01" {
  name        = "testing-stateless"
  capacity    = 100
  type        = "STATELESS"
  description = "Stateless rule to allow all ICMP traffic"

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        stateless_rule {
          rule_definition {
            match_attributes {
              protocols = [1] # Protocol 1 represents ICMP

              source {
                address_definition = "0.0.0.0/0" # Any source
              }

              destination {
                address_definition = "0.0.0.0/0" # Any destination
              }
            }

            actions = ["aws:pass"] # Allow the traffic
          }

          priority = 1 # Rule priority
        }
      }
    }
  }

  tags = {
    Name = "FW - ${var.project_name}"
  }
}


resource "aws_networkfirewall_firewall_policy" "nw-firewall-policy" {
  name = "firewall-policy-${var.project_name}"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.group-01.arn
    }
    
    stateless_rule_group_reference {
    priority = 1
    resource_arn = aws_networkfirewall_rule_group.stateless-01.arn
    }
  }
}
