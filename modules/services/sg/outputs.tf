####################
# Security Group
####################

output "security_group_id" {
  value = try(aws_security_group.this[0].id, null)
}