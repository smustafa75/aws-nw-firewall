output "VPC_Name" {
  description = "VPC Name"
  value       = module.network.vpcname
}


output "Private_Subnets" {
  description = "Private Subnets"
  value       = concat(module.network.private_net, module.network.private_subnets_cidr)
}

output "Public_Subnets" {
  description = "Public Subnets"
  value       = concat(module.network.public_net, module.network.public_subnets_cidr)
}
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


output "hana_db01" {
  value = module.compute.hana_db01_id
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

