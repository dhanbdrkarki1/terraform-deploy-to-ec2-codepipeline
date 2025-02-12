output "s3_bucket_name" {
  value       = try(module.s3.bucket_name, null)
  description = "The name of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = try(module.dynamodb.table_name, null)
  description = "The name of the DynamoDB table"
}
