output "log_group_name" {
  value = try(aws_cloudwatch_log_group.this[0].name, null)
}
output "log_group_arn" {
  value = try(aws_cloudwatch_log_group.this[0].arn, null)
}
