output "VPC_Name" {
  description = "VPC Name"
  value       = module.network.vpcname
}


output "Nat_gw_Subnets" {
  description = "NAT GW Subnets"
  value       = concat(module.network.nat_gateway_subnet, module.network.nat_gw_subnets_cidr)
}

output "Firewall_Subnets" {
  description = "Firewall Subnets"
  value       = concat(module.network.firewall_subnet, module.network.firewall_subnets_cidr)
}

output "Workload_Subnets" {
  description = "Workload Subnets"
  value       = concat(module.network.workload_subnet, module.network.workload_subnets_cidr)
}
