output "application_arn" {
  value = try(aws_codedeploy_app.this[0].arn, null)
}

output "application_name" {
  value = try(aws_codedeploy_app.this[0].name, null)
}

output "deployment_group_arn" {
  value = try(aws_codedeploy_deployment_group.this[0].arn, null)
}

output "deployment_group_name" {
  value = try(aws_codedeploy_deployment_group.this[0].deployment_group_name, null)
}

