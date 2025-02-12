output "instance_id" {
  value = try(aws_instance.this[*].id, [])
}

output "instance_ip" {
  value = try(aws_instance.this[*].public_ip, [])
}


output "ami_id" {
  description = "ID of the created AMI"
  value       = try(aws_ami_from_instance.this[0].id, null)
}

output "ami_arn" {
  description = "ARN of the created AMI"
  value       = try(aws_ami_from_instance.this[0].arn, null)
}
