aws_region       = "eu-west-2"
project_name     = "AWSNetworkFirewall"

vpc_cidr         = "172.31.0.0/16"

firewall_subnet   = ["172.31.1.0/24"]
workload_subnet = ["172.31.2.0/24"]
nat_gw_subnet  = ["172.31.3.0/24"]
instance_count   = "1"

flowlog_role = "VPC-Flowlog-Writer"
flowlog_policy = "VPCFlowLogsWriter"


ssm_role = "aws-ssm-role"
//AmazonS3FullAccess,AmazonSSMFullAccess,AmazonSSMManagedEC2InstanceDefaultPolicy, AmazonSSMManagedInstanceCore and CloudWatchAgent ServerPolicy

instance_profile = ""
accessip         = "0.0.0.0/0"

private_instance = "t2.micro"
private_ami      = ""
private_disk     = "60"
