output "bucket_arn" {
  value = try(aws_s3_bucket.this[0].arn, null)
}

output "bucket_name" {
  value = try(aws_s3_bucket.this[0].bucket, null)
}

output "bucket_id" {
  value = try(aws_s3_bucket.this[0].id, null)
}

output "bucket_regional_domain_name" {
  value = try(aws_s3_bucket.this[0].bucket_regional_domain_name, null)
}
