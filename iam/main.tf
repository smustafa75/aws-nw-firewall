resource "aws_iam_role" "ec2_access_role" {
  name               = var.role_name
  path = "/"
  managed_policy_arns = [
    "arn:${var.partition_info}:iam::aws:policy/service-role/AmazonSSMAutomationRole",
    aws_iam_policy.ssm-session-s3.arn,
    "arn:${var.partition_info}:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
    inline_policy {
    name = "PassRolePolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Effect" : "Allow",
          "Action" : "iam:PassRole",
          "Resource" : "*"
        }
      ]
    })
  }
  assume_role_policy = "${file("./iam/assumerolepolicy.json")}"

}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = "Access CW"
  policy      = "${file("./iam/policycw.json")}"
}

resource "aws_iam_policy" "s3_policy" {
  name        = var.s3_policy
  description = "Access S3"
  policy      = "${file("./iam/policys3.json")}"
}

resource "aws_iam_policy_attachment" "policy_to_role" {
  name       = "Cloudwatch access"
  roles      = [aws_iam_role.ec2_access_role.name] 
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_policy_attachment" "s3_policy_to_role" {
  name       = "S3 access"
  roles      = [aws_iam_role.ec2_access_role.name] 
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "iam_instance_profile"
  role = aws_iam_role.ec2_access_role.name 
}

resource "aws_iam_policy" "ssm-session-s3" {
  name        = "session-manager-s3"
  path        = "/"
  description = "Grant EC2 instance to communicate with SSM and S3"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:GetObject",
        "Resource" : [
          "arn:${var.partition_info}:s3:::aws-ssm-${var.region_info}/*",
          "arn:${var.partition_info}:s3:::aws-windows-downloads-${var.region_info}/*",
          "arn:${var.partition_info}:s3:::amazon-ssm-${var.region_info}/*",
          "arn:${var.partition_info}:s3:::amazon-ssm-packages-${var.region_info}/*",
          "arn:${var.partition_info}:s3:::${var.region_info}-birdwatcher-prod/*",
          "arn:${var.partition_info}:s3:::aws-ssm-distributor-file-${var.region_info}/*",
          "arn:${var.partition_info}:s3:::aws-ssm-document-attachments-${var.region_info}/*",
          "arn:${var.partition_info}:s3:::patch-baseline-snapshot-${var.region_info}/*",
          "arn:${var.partition_info}:imagebuilder:${var.region_info}:*:component/*",
          "arn:${var.partition_info}:imagebuilder:${var.region_info}:*:component/"



        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketLocation"

        ],
        "Resource" : "*"
      }
    ]
  })
}