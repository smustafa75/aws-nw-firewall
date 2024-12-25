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
/*output "private_instance" {
  value = module.compute.private_instance
}*/

/*
output "Bucket_ID" {
  value = module.storage.bucketname
}

output "Bucket_ARN" {
  value = module.storage.bucket_arn
}

output "SQL_Bucket_ID" {
  value = module.storage.sql_bucketname
}
output "SQL_Bucket_ARN" {
  value = module.storage.sql_bucket_arn
}



*/
/*
output "public_ip" {
  value = module.compute.hana_server_ip
}
output "role_name" {
  value = module.iam.iam_role
}
output "vpc_end_point" {
  value = module.network.vpc_endpoint

}
*/

