aws_region       = "eu-west-1"
project_name     = "ProjectInfrastructure"
vpc_cidr         = "172.31.0.0/16"
public_subnets   = ["172.31.81.0/24", "172.31.82.0/24"]
private_subnets  = ["172.31.83.0/24", "172.31.84.0/24"]
instance_count   = "2"
policy_name      = "Access_CW"
role_name        = "AccessCloudWatch"
s3_policy        = "Access_S3"
instance_profile = ""
accessip         = "0.0.0.0/0"

instance_hana_db01 = "XX.xlarge"
hana_db_ami01      = ""
hana_db_disk_root     = "100"
hana_db_disk_sap   = "100"
hana_db_disk_shared   = "500"
hana_db_disk_data   = "800"
hana_db_disk_log   = "150"

instance_hana_db02 = "XX.Xxlarge"
hana_db_ami02      = ""

instance_hana_app = "XX.Xlarge"
hana_app_ami      = ""
hana_app_disk    = "500"


instance_bastion = "t3.large"
bastion_ami      = ""
bastion_disk     = "300"

instance_web_sap = "XX.large"
web_sap_ami      = ""
web_sap_disk     = "300"

