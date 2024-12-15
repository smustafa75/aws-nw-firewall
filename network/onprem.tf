#terraform import module.network.aws_customer_gateway.cgw-xxx cgw-XXXX
/*
resource "aws_customer_gateway" "cgw-xxx" {
  bgp_asn    = 65000
  ip_address = "10.10.10.1"
  type       = "ipsec.1"

  tags = {
    Name = "CGW"
  }
}

resource "aws_vpn_gateway" "vpg-xxx" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "VPG"
  }
}*/