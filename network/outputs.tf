
output "nat_gateway_subnet" {
  value = aws_subnet.nat_gw_subnet.*.id
}

output "firewall_subnet" {
  value = aws_subnet.firewall_subnet.*.id
}

output "workload_subnet" {
  value = aws_subnet.workload_subnet.*.id
}

output "vpcname" {
  value = aws_vpc.fw_vpc.id
}

output "private_security_group" {
  value = aws_security_group.private_sg.id
}


output "nat_gw_subnets_cidr" {
  value = aws_subnet.nat_gw_subnet.*.cidr_block
}

output "firewall_subnets_cidr" {
  value = aws_subnet.firewall_subnet.*.cidr_block
}

output "workload_subnets_cidr" {
  value = aws_subnet.workload_subnet.*.cidr_block
}

output "public_security_group" {
  value = aws_security_group.public_sg.id
}

output "vpc_endpoint" {
  value = aws_vpc_endpoint.s3_endpoint.id
}