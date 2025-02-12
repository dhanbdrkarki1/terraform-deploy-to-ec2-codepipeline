output "repository_name" {
  value       = try(aws_codecommit_repository.this[0].repository_name, null)
  description = "The name of the CodeCommit repository"
}

output "clone_url_http" {
  value       = try(aws_codecommit_repository.this[0].clone_url_http, null)
  description = "The name of the AWS CodeCommit Repository"
}

output "arn" {
  value       = try(aws_codecommit_repository.this[0].arn, null)
  description = "The arn of the CodeCommit repository"
}
