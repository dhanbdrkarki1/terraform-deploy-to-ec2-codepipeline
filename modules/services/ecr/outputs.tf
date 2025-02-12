#################################
# Elastic Container Registry
#################################

output "repository_name" {
  value = try(aws_ecr_repository.ecr[0].name, null)
}

output "repository_url" {
  value = try(aws_ecr_repository.ecr[0].repository_url, null)
}

output "arn" {
  value = try(aws_ecr_repository.ecr[0].arn, null)
}
