/*provider "aws" {
  region  = var.aws_region
  profile = "default"
}*/

provider "aws" {
  region  = var.aws_region
  profile = "render"
}

module "network" {
  source          = "./network"
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  region_info     = data.aws_region.current.name
 // logging_bucket  = module.storage.bucket_arn
  project_name    = var.project_name

}
/*
module "storage" {
  source       = "./storage"
  project_name = var.project_name
  vpcendpoint  = module.network.vpc_endpoint
  region_info    = data.aws_region.current.name

  depends_on = [
    module.network.aws_vpc_endpoint
  ]
}
*/

module "compute" {
  source     = "./compute"
  aws_region = var.aws_region


  instance_hana_db01 = var.instance_hana_db01
  hana_db_ami01      = var.hana_db_ami01
  hana_db_disk_root    = var.hana_db_disk_root
  hana_db_disk_sap   = var.hana_db_disk_sap
  hana_db_disk_shared = var.hana_db_disk_shared
  hana_db_disk_data= var.hana_db_disk_data
  hana_db_disk_log= var.hana_db_disk_log

  instance_hana_db02 = var.instance_hana_db01
  hana_db_ami02      = var.hana_db_ami02


  instance_hana_app = var.instance_hana_app
  hana_app_ami      = var.hana_app_ami
  hana_app_disk    = var.hana_app_disk


  instance_bastion = var.instance_bastion
  bastion_ami      = var.bastion_ami
  bastion_disk     = var.bastion_disk

  instance_web_sap = var.instance_web_sap
  web_sap_ami      = var.web_sap_ami
  web_sap_disk     = var.web_sap_disk

  public_net             = module.network.public_net
  public_security_group  = module.network.public_security_group
  private_net            = module.network.private_net
  private_security_group = module.network.private_security_group
  instance_profile       = module.iam.iam_instance_profile_arn
  vpc_id                 = module.network.vpcname

  project_name = var.project_name


  #instance_count   = var.instance_count
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


module "cloudwatch" {
  source         = "./cloudwatch"
  hana_db01    = module.compute.hana_db01_id
  hana_db02    = module.compute.hana_db02_id
  region_info    = data.aws_region.current.name
  account_id     = data.aws_caller_identity.current.account_id
  partition_info = data.aws_partition.current.partition
}