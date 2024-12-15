output "bucketname" {
  value = aws_s3_bucket.tf_code_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.tf_code_bucket.arn
}

output "sql_bucketname" {
  value = aws_s3_bucket.sql_data_bucket.id
}

output "sql_bucket_arn" {
  value = aws_s3_bucket.sql_data_bucket.arn
}

output "cloudtrail_bucketname" {
  value = aws_s3_bucket.poc-cloudtrail-bucket.id
}

output "cloudtrail_bucket_arn" {
  value = aws_s3_bucket.poc-cloudtrail-bucket.arn
}

