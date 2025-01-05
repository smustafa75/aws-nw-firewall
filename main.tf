
provider "aws" {
  region  = var.aws_region
  profile = "render"
}

module "network" {
  source          = "./network"
  vpc_cidr        = var.vpc_cidr
  firewall_subnet = var.firewall_subnet
  workload_subnet  = var.workload_subnet
  nat_gw_subnet = var.nat_gw_subnet
  region_info     = data.aws_region.current.name
  project_name    = var.project_name

}

module "compute" {
  source     = "./compute"
  aws_region = var.aws_region


  private_instance = var.private_instance
  private_ami      = var.private_ami
  private_disk     = var.private_disk


  workload_net             = module.network.workload_subnet
  public_security_group  = module.network.public_security_group
  private_security_group = module.network.private_security_group
  instance_profile       = module.iam.iam_instance_profile
  vpc_id                 = module.network.vpcname

  project_name = var.project_name

  depends_on = [
    module.iam.iam_instance_profile_arn
  ]
}


module "iam" {
  source         = "./iam"
  policy_name    = var.policy_name
  s3_policy      = var.s3_policy
  role_name      = var.role_name
  region_info    = data.aws_region.current.name
  account_id     = data.aws_caller_identity.current.account_id
  partition_info = data.aws_partition.current.partition
}
