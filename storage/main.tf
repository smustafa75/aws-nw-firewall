data "aws_caller_identity" "current" {}
# generate random id
resource "random_id" "tf_bucket_id" {
  byte_length = 2
}

# generate S3 bucket
resource "aws_s3_bucket" "tf_code_bucket" {
  bucket        = "${var.project_name}-${random_id.tf_bucket_id.dec}"
  force_destroy = true
  tags = {
    Name = "S3 - Module"
  }
}
/*
resource "aws_s3_bucket_acl" "tf_code_acl" {
  bucket = aws_s3_bucket.tf_code_bucket.id
  acl    = "private"
}*/

# Template
data "template_file" "s3_policy_work" {
  template = templatefile("${path.module}/policy_vpce.json", {
    bucket_arns = aws_s3_bucket.tf_code_bucket.arn
    source_vpc = var.vpcendpoint
    aws_acct = data.aws_caller_identity.current.account_id
    region_info = var.region_info

  })
  depends_on = [
    aws_s3_bucket.tf_code_bucket
  ]
}
# Bucket Policy
resource "aws_s3_bucket_policy" "bucket_policy_01" {
  bucket = aws_s3_bucket.tf_code_bucket.id

  policy = data.template_file.s3_policy_work.template
 }

# generate S3 bucket
resource "aws_s3_bucket" "sql_data_bucket" {
  bucket        = "${var.project_name}-sql-${random_id.tf_bucket_id.dec}"
  force_destroy = true
  tags = {
    Name = "S3 - Module Backup"
  }
}
/*
resource "aws_s3_bucket_acl" "sql_acl" {
  bucket = aws_s3_bucket.sql_data_bucket.id
  acl    = "private"
}*/
# Template

/*data "template_file" "s3_sql_policy_work" {
  template = templatefile("${path.module}/policy_vpce.json", {
    bucket_arns = aws_s3_bucket.sql_data_bucket.arn
    source_vpc = var.vpcendpoint

  })
  depends_on = [
    aws_s3_bucket.sql_data_bucket
  ]
}*/
# Bucket Policy
/*resource "aws_s3_bucket_policy" "bucket_policy_02" {
  bucket = aws_s3_bucket.sql_data_bucket.id

  policy = data.template_file.s3_sql_policy_work.template
 }*/


 #Cloudtrail
 resource "aws_cloudtrail" "poc-trail" {
  name                          = "${var.project_name}-poc-cloud-trail"
  s3_bucket_name                = aws_s3_bucket.poc-cloudtrail-bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
}

resource "aws_s3_bucket" "poc-cloudtrail-bucket" {
  bucket        = "poc-trail-${var.project_name}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "poc-trail-policy" {
  bucket = aws_s3_bucket.poc-cloudtrail-bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.poc-cloudtrail-bucket.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.poc-cloudtrail-bucket.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
