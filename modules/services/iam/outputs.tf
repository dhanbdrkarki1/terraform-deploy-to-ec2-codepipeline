output "user_arns" {
  description = "Map of user names to their ARNs"
  value       = { for k, v in aws_iam_user.users : k => v.arn }
}

output "group_arns" {
  description = "Map of group names to their ARNs"
  value       = { for k, v in aws_iam_group.groups : k => v.arn }
}

output "custom_policy_arns" {
  description = "Map of custom policy names to their ARNs"
  value       = { for k, v in aws_iam_policy.custom_policies : k => v.arn }
}

# Role and Instance Profile
output "role_arn" {
  description = "The ARN of the IAM role"
  value       = try(aws_iam_role.this[0].arn, null)
}

output "policy_arn" {
  description = "The ARN of the IAM policy"
  value       = try(aws_iam_policy.this[0].arn, null)
}

output "instance_profile_name" {
  description = "The IAM Instance Profile to launch the instance with"
  value       = try(aws_iam_instance_profile.this[0].name, null)
}
