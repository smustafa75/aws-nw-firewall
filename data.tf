data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "current" {}

# Get the current AWS partition
data "aws_partition" "current" {}